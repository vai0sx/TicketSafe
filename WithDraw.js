import React, { Component } from 'react';
import { Button } from 'react-bootstrap';
import PropTypes from 'prop-types';
import { getWeb3, getContractInstance } from '../web3';

class Withdraw extends Component {
  state = {
    web3: null,
    contract: null,
  };

  async componentDidMount() {
    try {const web3 = await getWeb3();
        const contract = await getContractInstance(web3);
        this.setState({ web3, contract });
        } catch (error) {
        console.error(error);
        }
        }
        
        handleWithdraw = async () => {
        try {
        const accounts = await this.state.web3.eth.getAccounts();
        await this.state.contract.methods
        .withdraw(this.props.match.params.experienceId)
        .send({ from: accounts[0] });
        alert('Fondos retirados con éxito');
        } catch (error) {
        console.error(error);
        alert('Error al retirar fondos');
        }
        };
        
        render() {
        return (
        <div>
        <h1>Retirar Fondos</h1>
        <Button onClick={this.handleWithdraw}>Retirar</Button>
        </div>
        );
        }
        }

        Withdraw.propTypes = {
          match: PropTypes.shape({
            params: PropTypes.shape({
              experienceId: PropTypes.string.isRequired,
            }).isRequired,
          }).isRequired,
        };
        
        export default Withdraw;
