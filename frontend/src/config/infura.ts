const infuraId = process.env.REACT_REACT_APP_INFURA_ID;

const infuraMainnetHttps = 'https://mainnet.infura.io/v3/'
const infuraMainnetWs = 'wss://mainnet.infura.io/v3/'

const infuraRinkebyHttps = 'https://rinkeby.infura.io/v3/'
const infuraRinkebyWs = 'wss://rinkeby.infura.io/ws/v3/'

export const infuraConfig = {
  1: {
    https: infuraMainnetHttps + infuraId,
    ws: infuraMainnetWs + infuraId
  },
  4: {
    https: infuraRinkebyHttps + infuraId,
    ws: infuraRinkebyWs + infuraId
  }
}