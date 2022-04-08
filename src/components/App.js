import React, {Component} from 'react';
// import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
// import KryptoBird from '../abis/Kryptobird.json';

class App extends Component{

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    };
 
    async loadWeb3() {
        const provider = await detectEthereumProvider();
 
        if(provider) {
            console.log('It is working');
        } else {
            console.log('No Ethereum Wallet Detected');
        };
    };
 
    async loadBlockchainData() {
        const accounts = await window.ethereum.request( {method: 'eth_requestAccounts'} );
        this.setState({
            acccount: accounts
        })
        console.log(this.state.account);
    };

    constructor(props){
        super(props);
        this.state = {
            account: '2',
        }

    }

    render(){
        return(
            <div>
                <h1>NFT Marketplace</h1>
            </div>
        )
    }

}

export default App;