import React, {Component} from 'react';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import KryptoBird from '../abis/Kryptobird.json';

class App extends Component{

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    };
 
    async loadWeb3() {
        const provider = await detectEthereumProvider();
        
 
        if(provider) {
            console.log('It is working');
            // Create web3 object
            window.web3 = new Web3(provider);
        } else {
            console.log('No Ethereum Wallet Detected');
        };
    };
 
    async loadBlockchainData() {
        const web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        this.setState({ account: accounts[0] })

        const networkID = await web3.eth.net.getId();
        console.log(networkID)
        const networkData = KryptoBird.networks[networkID];
        console.log(networkData)

        if (networkData) {
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            this.setState({ contract });
            const totalSupply = await contract.methods.totalSupply().call();
            this.setState({ totalSupply });

            for (let i = 1; i <= totalSupply; i++) {
                const KryptoBird = await contract.methods.kryptoBirdz(i - 1).call();
                this.setState({
                    kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
                })
            }
            console.log(this.state.kryptoBirdz)


        } else {
            window.alert('Smart contract not deployed');
        }
    }

    mint = (kryptoBird) =>{
        this.state.contract.methods.mint(kryptoBird).send({from: this.state.account})
        .once('recepit', (receipt) =>{
            this.setState({
                kryptoBirdz: [...this.state.kryptoBirdz, KryptoBird]
            })
        })
    }





    constructor(props){
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            kryptoBirdz: []
        }

    }

    render(){
        return(
            <div>
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
                    <div className='navbar-brand col-sm-3 col-md-3 mr-0' style = {{color: 'white'}}>
                        Krypto Birdz NFTs (Non Fungible Tokens)
                    </div>
                    <ul className='navbar-nav px-3'> 
                        <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className='text-white'>
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className='container-fluid mt-1'>
                    <div className='row'>
                        <main role='main' className='col-lg-12 d-flex text-center'>
                            <div className='content mr-auto ml-auto'
                            style={{opacity:'0.8'}}>
                                <h1>KryptoBirdz - NFT Marketplace</h1>

                            </div>

                        </main>

                    </div>
                </div>



            </div>
            
        )
    }

}

export default App;