import React from 'react'
import Container from '@mui/material/Container'
import { Grid } from '@mui/material'
import { styled } from '@mui/material/styles'
import Paper from '@mui/material/Paper'

import {metadata, ipfsGateway, Tmedata} from '../config/metadata'


const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(1),
  textAlign: 'center',
  color: theme.palette.text.secondary,
}));

const Img = styled('img')({
  margin: 'auto',
  display: 'block',
  maxWidth: '100%',
  maxHeight: '100%',
});

function Home() {
  return (
    <Container 
      component="main"
      maxWidth={false}
      style={{flex: 1}}
      sx={{ pt: 4, pb: 4, pl: 4, pr: 4}}
    >
      <Grid container spacing={2} columns={{ xs: 12, md: 10 }}>
        {
          Object.keys(metadata).map((id) => {
            return (
              <Grid item xs={12} sm={6} md={2}>
                <Item>
                  <Img src={metadata[id].image.replace("ipfs://", ipfsGateway)} />
                </Item>
              </Grid>
            )
          })
        }
      </Grid>
    </Container>
  )
}

export default Home