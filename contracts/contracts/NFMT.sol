// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFMT is ERC1155, Ownable, Pausable, ERC1155Supply {
    string public constant name = "Never Forget Memory Token";
    string public constant symbol = "NFMT";

    uint constant public BRONZE_MAX_SUPPLY = 245;
    uint constant public STEEL_MAX_SUPPLY = 100;
    uint constant public SILVER_MAX_SUPPLY = 50;
    uint constant public GOLD_MAX_SUPPLY = 20;
    uint constant public DIAMOND_MAX_SUPPLY = 5;

    uint constant public STEEL_COST = 50000000000000000; // 0.05
    uint constant public SILVER_COST = 100000000000000000; // 0.1 Eth
    uint constant public GOLD_COST = 300000000000000000; // 0.3 Eth
    uint constant public DIAMOND_COST = 1000000000000000000; // 1 Eth

    address constant CHARITY1 = 0x68B11194369F0145a86C855c1db1750BD51CC8de;
    address constant CHARITY2 = 0x21f5874aBC2c220d0Da49D142000D9dc75289C42;
    address constant CHARITY3 = 0xe315f685aA63d0B17AE4fd8AAfCAF2C811BE34c0;

    mapping(address => uint) public balances;

    constructor() ERC1155("") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(uint256 id, uint256 amount)
        public
        payable
    {
        require(id > 0 && id < 6, "");

        address sender = _msgSender();
        uint _totalSupply = totalSupply(id);

        if (id == 1) {
            require(_totalSupply < BRONZE_MAX_SUPPLY && amount == 1, "");
            return _mint(sender, id, amount, "");
        }

        if (id == 2) {
            require(_totalSupply < STEEL_MAX_SUPPLY && msg.value >= (STEEL_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        if (id == 3) {
            require(_totalSupply < SILVER_MAX_SUPPLY && msg.value >= (SILVER_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        if (id == 4) {
            require(_totalSupply < GOLD_MAX_SUPPLY && msg.value >= (GOLD_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        if (id == 5) {
            require(_totalSupply < DIAMOND_MAX_SUPPLY && msg.value >= (DIAMOND_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        uint256 oneQuarter = msg.value / 4;
        balances[CHARITY1] += oneQuarter + oneQuarter;
        balances[CHARITY2] += oneQuarter;
        balances[CHARITY3] += oneQuarter;
    }

    function uri(uint256 tokenId) override public pure returns (string memory) {
        return (
            string(abi.encodePacked(
                "ipfs://",
                Strings.toString(tokenId),
                ".json"
            ))
        );
    }

    function withdraw() public {
        address sender = _msgSender();
        payable(sender).transfer(balances[sender]);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}