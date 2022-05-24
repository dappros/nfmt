import * as React from 'react'
import * as PropTypes from 'prop-types'

import './styles.scss'

import {
  getChainData
} from '../../helpers/utilities'

interface IHeaderProps {
  killSession: () => void;
  connected: boolean;
  address: string;
  chainId: number;
  onConnect: () => void;
}

const Header = (props: IHeaderProps) => {
  const { connected, address, chainId, killSession, onConnect } = props
  const chainData = chainId ? getChainData(chainId) : null
  return (
    <div {...props} className="app-header">
      <div className="app-header-left">
        { connected && chainData && (
          <div className="header-disconnect">
            <p>Connected to: {chainData.name}, address: {address}</p>
                
          </div>
        )
        }
      </div>
      <div className="app-header-right">
        {
          !address && (
            <button onClick={onConnect}>connect</button>
          )
        }
        {
          address && (
            <button onClick={killSession}>{'Disconnect'}</button>
          )
        }
      </div>
    </div>
  )
}

Header.propTypes = {
  killSession: PropTypes.func.isRequired,
  onConnect: PropTypes.func.isRequired,
  address: PropTypes.string,
}

export default Header
