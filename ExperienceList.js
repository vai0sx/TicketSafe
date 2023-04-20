import React, { Component } from 'react';
import { getWeb3, getContractInstance } from '../web3';

class ExperienceList extends Component {
  state = {
    web3: null,
    contract: null,
    experiences: [],
  };

  async componentDidMount() {
    console.log('ExperienceList component mounted');
    try {
      const web3 = await getWeb3();
      const contract = await getContractInstance(web3);
      this.setState({ web3, contract });

      const experienceCount = await contract.methods.experienceCount().call();
      const experiences = [];
      for (let i = 1; i <= experienceCount; i++) {
        const experience = await contract.methods.experiences(i).call();
        experiences.push(experience);
      }
      this.setState({ experiences });
    } catch (error) {
      console.error(error);
    }
  }

  render() {
    return (
      <div>
        <h1>List of Experiences</h1>
        <ul>
          {this.state.experiences.map((experience, index) => (
            <li key={index}>
              {experience.name} - {experience.price} - {experience.date}
            </li>
          ))}
        </ul>
      </div>
    );
  }
}

export default ExperienceList;
