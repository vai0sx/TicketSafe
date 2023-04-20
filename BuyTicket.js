import React, { Component } from 'react';
import { Button } from 'react-bootstrap';
import PropTypes from 'prop-types';
import { getWeb3, getContractInstance } from '../web3';

class BuyTicket extends Component {
  state = {
    web3: null,
    contract: null,
    experience: null,
  };

  async componentDidMount() {
    try {
      const web3 = await getWeb3();
      const contract = await getContractInstance(web3);
      this.setState({ web3, contract });

      const experienceId = this.props.match.params.experienceId;
      const experience = await contract.methods.experiences(experienceId).call();
      this.setState({ experience });
    } catch (error) {
      console.error(error);
    }
  }

  handleBuyTicket = async () => {
    try {
      const accounts = await this.state.web3.eth.getAccounts();
      await this.state.contract.methods
        .buyTicket(this.props.match.params.experienceId)
        .send({ from: accounts[0], value: this.state.experience.price });
      alert('Ticket purchased successfully');
    } catch (error) {
      console.error(error);
      alert('Error when buying ticket');
    }
  };

  render() {
    const { experience } = this.state;
    if (!experience) return <div>Loading...</div>;

    return (
      <div> 
        <h1>Buy Ticket</h1>
        <h2>{experience.name}</h2>
        <h3>Price: {experience.price}</h3>
        <Button onClick={this.handleBuyTicket}>Buy</Button>
      </div>
    );
  }
}

BuyTicket.propTypes = {
  match: PropTypes.shape({
    params: PropTypes.shape({
      experienceId: PropTypes.string.isRequired,
    }).isRequired,
  }).isRequired,
};

export default BuyTicket;
