export type Tmedata = {
  name: string,
  desctiption: string,
  image: string,
  attributes: {value: string}[]
}

export type TmetadataObj = {
  [key: number]: Tmedata
}

export const metadata: TmetadataObj = {
  1: {
    "name": "NFMT #1",
    "desctiption": "Never Forget Memory Token desctiption",
    "image": "ipfs://QmPSgSfXcnC9symREqCdSBUPrZbCsBc7RFVTvtouDpLLTC/1.png",
    "attributes": [
      {
        "value": "BRONZE"
      }
    ]
  },
  2: {
    "name": "NFMT #2",
    "desctiption": "Never Forget Memory Token desctiption",
    "image": "ipfs://QmPSgSfXcnC9symREqCdSBUPrZbCsBc7RFVTvtouDpLLTC/2.png",
    "attributes": [
      {
        "value": "STEEL"
      }
    ]
  },
  3: {
    "name": "NFMT #3",
    "desctiption": "Never Forget Memory Token desctiption",
    "image": "ipfs://QmPSgSfXcnC9symREqCdSBUPrZbCsBc7RFVTvtouDpLLTC/3.png",
    "attributes": [
      {
        "value": "SILVER"
      }
    ]
  },
  4: {
    "name": "NFMT #4",
    "desctiption": "Never Forget Memory Token desctiption",
    "image": "ipfs://QmPSgSfXcnC9symREqCdSBUPrZbCsBc7RFVTvtouDpLLTC/4.png",
    "attributes": [
      {
        "value": "GOLD"
      }
    ]
  },
  5: {
    "name": "NFMT #5",
    "desctiption": "Never Forget Memory Token desctiption",
    "image": "ipfs://QmPSgSfXcnC9symREqCdSBUPrZbCsBc7RFVTvtouDpLLTC/5.png",
    "attributes": [
      {
        "value": "DIAMOND"
      }
    ]
  }
}

export const ipfsGateway = "https://dapprossplatform.mypinata.cloud/ipfs/"