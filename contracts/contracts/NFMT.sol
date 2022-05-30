// ©️ 2022 Dappros Ltd, project by Taras Filatov, Borys Bordunov, Mykhaylo Mohilyuk
// 🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦 "Never Forget" Memory/Meme Token 🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦
// 👋 open source - feel free to fork/copy/reuse this smart contract for your needs 👋
// 📖 learn more at https://github.com/dappros/nfmt/ 📖

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFMT is ERC1155, Ownable, Pausable, ERC1155Supply, ReentrancyGuard {

    // You can change this to your own collection name
    string public constant name = "Never Forget Memory Token";
    
    // You can change this to your own collection symbol
    string public constant symbol = "NFMT";

    // *** [🟢 CLASSES AND RARITY] ********************************************************************************************************************************

    // 🇺🇦: РОЗДІЛ "RARITY" - тут можна вказати які типи токенів є в вашої колекції, яка їх рідкість (скільки взагалі буде випущено кожного класу) та вартість мінту
    // 🇺🇦: (Ви можете пропустити це й скористатися стандартним набором класів і цін).
    // 🇬🇧🇺🇸: RARITY SECTION - Here you can specify what types of tokens are in your collection, what is their rarity (how many will be issued in each class) and the cost of a mint
    // 🇬🇧🇺🇸: (Alternatively you can skip this and go ahead with a defaul set of classes and prices.)

    // 🇺🇦: скільки існує "бронзових" токенів вашої колекції (безкоштовні, обмежені тільки кількістю)
    // 🇬🇧🇺🇸: how many "Bronze" copies can be minted (by default, these are free to mint)
    uint constant public BRONZE_MAX_SUPPLY = 245; // 🥉


    // 🇺🇦: скільки існує "сталевих" токенів вашої колекції (коштує 0.05 ETH)
    // 🇬🇧🇺🇸: how many "Steel" copies can be minted (by default, these cost 0.05 ETH)
    uint constant public STEEL_MAX_SUPPLY = 100; // 🔩

    // 🇺🇦: так само, але кожний тип дорожчий та потребує більшого донату
    // 🇬🇧🇺🇸: same as above, but each type is more rare and requires a higher donation
    uint constant public SILVER_MAX_SUPPLY = 50; // 🥈
    uint constant public GOLD_MAX_SUPPLY = 20; // 🥇
    uint constant public DIAMOND_MAX_SUPPLY = 5; // 💎

    // 🇺🇦: тепер вказуємо "ціну" мінту (розмір благодійного внеску) для кожного класу. Пам'ятаємо що перший (бронзовий) клас - безкоштовний.
    // 🇬🇧🇺🇸: let's set the donation required for minting each class (remember our Bronze ones are free?) // 🥉 = 0 ETH
    uint constant public STEEL_COST = 50000000000000000; // 🔩 = 0.05 ETH
    uint constant public SILVER_COST = 100000000000000000; // 🥈 = 0.1 ETH
    uint constant public GOLD_COST = 300000000000000000; // 🥇 = 0.3 ETH
    uint constant public DIAMOND_COST = 1000000000000000000; // 💎 = 1 ETH

    // *** [🛑 CLASSES AND RARITY] ********************************************************************************************************************************
    

    // *** [🟢 FUNDS DISTRIBUTION ] ********************************************************************************************************************************

    // 🇺🇦: !!ВАЖЛИВО!! - замініть ці адреси на адреси ETH благодійних організацій / волонтерів, яких ви хочете підтримати!
    // 🇬🇧🇺🇸: !!IMPORTANT!! - replace these addresses with ETH addresses of charities / volunteers whom you want to support!

    address constant CHARITY1 = 0x12c546c89E4158b151597d761048A5C33C4f54CC; // example N1 - 0x12c546c89E4158b151597d761048A5C33C4f54CC - "NOVA Ukraine", https://novaukraine.org/donate/
    address constant CHARITY2 = 0xba65e794d8aec422d0d71cce1095c63da579e144; // example N2 - 0xba65e794d8aec422d0d71cce1095c63da579e144 - "GO Solidarna Sprava Gromad", Yurii Biryukov https://www.facebook.com/yuri.biriukov 
    address constant CHARITY3 = 0xaD7F901b1eba489552c37b071b7D97DDB2DF27B6; // example N3 - 0xaD7F901b1eba489552c37b071b7D97DDB2DF27B6 - Demokratichna Sokyra (D7), https://sokyra.space/uk#help

    // some other addresses you might consider:
    // address constant CHARITY1 = 02x93Bda139023d582C19D70F55561f23D3CA6a54c; // "Come back alive" https://www.comebackalive.in.ua/donate
    // address constant CHARITY1 = 0xA4166BC4Be559b762B346CB4AAad3b051E584E39; // "RazomForUkrane" - https://razomforukraine.org/donate/

    // 🇺🇦: логіка по виплатах - скільки платити на яку адресу (в нашому прикладі перша отримує 50%, а друга та третя по 25%)
    // 🇺🇦: (замінить на логіку яка вам потрібна). 
    // 🇺🇦: Примітка: таке саме розподілення буде також для оплат що йдуть напряму на контракт.
    // 🇬🇧🇺🇸: pay out logic - how much to pay to which address (in our example CHARITY1 receives 50%, while second and third receive 25% each)
    // 🇬🇧🇺🇸: (replace with your own logic as required). 
    // 🇬🇧🇺🇸: Note: same distirubtion will be applied to payments that go directly to the contract.

    // ** PAYOUT DISTRIBUTION: MULTIPLE BENEFICIARIES **
    function distribute(uint value) private {
        uint256 oneQuarter = value / 4;
        balances[CHARITY1] += oneQuarter + oneQuarter;
        balances[CHARITY2] += oneQuarter;
        balances[CHARITY3] += oneQuarter;
    }

    // ** PAYOUT DISTRIBUTION: SINGLE BENEFICIARY **
    // 🇺🇦: логіка по виплатах, якщо адреса тільки одна
    // 🇬🇧🇺🇸: pay out logic - how much to pay, if address is only one
    // function distribute(uint value) private {
    //     balances[CHARITY1] += value;
    // }

    // ** WITHDRAW **
    // 🇺🇦: Цю функцію може викликати КОЖНИЙ, хто готовий витратити газ, щоб вивести накопичені кошти на один із ПРИЗНАЧЕНИХ РАНІШЕ гаманців фінансування.
    // 🇺🇦: (Тобто - фінансування йде зазначеним благодійним фондам, але запит на виплату може відправити будь хто.)
    // 🇬🇧🇺🇸: This function can be called by ANYONE who is willing to spend gas to withdraw the accumulated funds to one of the PRE-DEFINED funding wallets.
    // 🇬🇧🇺🇸: (So funding will always go to the pre-set charities etc, but the pay out can be requested by anyone.)

    function withdraw(address _to) public nonReentrant {
        require(balances[_to] != 0, "");
        payable(_to).transfer(balances[_to]);
        balances[_to] = 0;
    }

    // *** [🛑 FUNDS DISTRIBUTION ] ********************************************************************************************************************************


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

        distribute(msg.value);
    }


    // 🇺🇦: поміняйте тут посилання IPFS "ipfs://Qmcw.." на посилання до ваших метаданих 
    // 🇬🇧🇺🇸: replace IPFS link here "ipfs://Qmcw.." with your own metadata source
    function uri(uint256 tokenId) override public pure returns (string memory) {
        return (
            string(abi.encodePacked(
                "ipfs://QmcwELSVvGxegzAAm9WBZJCAv36LxADNXBZVxfmrctz3pA/",
                Strings.toString(tokenId),
                ".json"
            ))
        );
    }

    receive() external payable {
        require(msg.value > 0, "");
        distribute(msg.value);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
