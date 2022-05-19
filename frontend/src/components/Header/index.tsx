import * as React from "react";
import * as PropTypes from "prop-types";

import {
  getChainData
} from "../../helpers/utilities";

interface IHeaderProps {
  killSession: () => void;
  connected: boolean;
  address: string;
  chainId: number;
}

const Header = (props: IHeaderProps) => {
  const { connected, address, chainId, killSession } = props;
  const chainData = chainId ? getChainData(chainId) : null;
  return (
    <div {...props}>
      {connected && chainData ? (
        <div>
          <p>{`Connected to`}</p>
          <p>{chainData.name}</p>
        </div>
      ) : (
        <div>Banner</div>
      )}
      {address && (
        <div>
          <div>address - {address}</div>
          <button onClick={killSession}>{"Disconnect"}</button>
          {/* <SAddress connected={connected}>{ellipseAddress(address)}</SAddress>
          <SDisconnect connected={connected} onClick={killSession}>
            {"Disconnect"}
          </SDisconnect> */}
        </div>
      )}
    </div>
  );
};

Header.propTypes = {
  killSession: PropTypes.func.isRequired,
  address: PropTypes.string,
};

export default Header;
