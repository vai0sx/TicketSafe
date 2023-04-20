import React, { useState, useEffect } from 'react';
import { Button, Typography, Grid } from '@material-ui/core';
import PropTypes from 'prop-types';
import { getWeb3, getContractInstance } from '../web3';
import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
  root: {
    padding: theme.spacing(4),
  },
}));

const ConfirmAttendance = ({ match }) => {
  const [web3, setWeb3] = useState(null);
  const [contract, setContract] = useState(null);
  const classes = useStyles();

  useEffect(() => {
    const setup = async () => {
      try {
        const web3 = await getWeb3();
        const contract = await getContractInstance(web3);
        setWeb3(web3);
        setContract(contract);
      } catch (error) {
        console.error(error);
      }
    };
    setup();
  }, []);

  const handleConfirmAttendance = async () => {
    try {
      const { experienceId } = match.params;
      const accounts = await web3.eth.getAccounts();
      await contract.methods.confirmAttendance(parseInt(experienceId)).send({ from: accounts[0] });
      alert('Attendance to the event confirmed successfully');
    } catch (error) {
      console.error(error);
      alert('Error confirming your attendance to the event');
    }
  };

  return (
    <div className={classes.root}>
      <Grid container spacing={3}>
        <Grid item xs={12}>
          <Typography variant="h1" component="h1" gutterBottom>
            Confirm Attendance
          </Typography>
        </Grid>
        <Grid item xs={12}>
          <Button variant="contained" color="primary" onClick={handleConfirmAttendance}>
            Confirmar
          </Button>
        </Grid>
      </Grid>
    </div>
  );
};

ConfirmAttendance.propTypes = {
  match: PropTypes.shape({
    params: PropTypes.shape({
      experienceId: PropTypes.string.isRequired,
    }).isRequired,
  }).isRequired,
};

export default ConfirmAttendance;
