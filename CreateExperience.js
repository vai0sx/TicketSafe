import React, { useState, useEffect } from 'react';
import { Container, Grid, TextField, Checkbox, FormControlLabel, Typography, Button } from '@mui/material';
import { getWeb3, getContractInstance } from '../web3';
import TicketSafe from './TicketSafe.json';

class Seat {
  constructor(rows, columns, occupied, ticketId) {
    this.rows = rows;
    this.columns = columns;
    this.occupied = occupied;
    this.ticketId = ticketId;
  }
}

class SeatType {
  constructor(seat_type, id, available, owner) {
    this.seat_type = seat_type;
    this.id = id;
    this.available = available;
    this.owner = owner;
  }
}

const CreateExperience = () => {
  const [web3, setWeb3] = useState(null);
  const [contract, setContract] = useState(null);
  const [state, setState] = useState({
    isEvent: false,
    isService: false,
    isExperiencePOAP: false,
    name: '',
    category: '',
    description: '',
    location: '',
    date: '',
    dates: [],
    availableHours: [],
    merchandiseQuantity: '',
    ipfsPhotoHash: '',
    ipfsVideoHash: '',
    cancellationPeriod: '',
    expirationTime: '',
    resellable: false,
    minPrice: '',
    maxPrice: '',
    refunded: false,
    streamingPlatform: '',
    ticketPrice: '',
    maxTickets: '',
    rating: '',
    review: '',
    virtualLocation: '',
    currency: '',
    authenticityCertificate: '',
    qrCode: '',
    seats: [],
    seatTypes: [],
    totalTicketsSold: '',
  });

  useEffect(() => {
    const setup = async () => {
      try {
        const web3 = await getWeb3();
        const contract = new web3.eth.Contract(TicketSafe.abi, 0x229096Cd0D026D17C80Db369B21498fA77040827);
        setWeb3(web3);
        setContract(contract);
      } catch (error) {
        console.error(error);
      }
    };    
    setup();
  }, []);

  const handleChange = (event) => {
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;

    if (Array.isArray(state[name])) {
      setState({ ...state, [name]: value.split(',') });
    } else {
      setState({ ...state, [name]: value });
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const { isEvent, isService, isExperiencePOAP, name, date, ticketPrice, maxTickets, numSeats } = state;

    try {
      const accounts = await web3.eth.getAccounts();
      await contract.methods.createExperience(isEvent, isService, isExperiencePOAP, name, date, ticketPrice, maxTickets, numSeats).send({ from: accounts[0] });
      alert('Experiencia creada con éxito');
    } catch (error) {
      console.error(error);
      alert('Error al crear experiencia');
    }
  };

  return (
    <div>
      <Typography variant="h4">Create Experience</Typography>
      <form onSubmit={handleSubmit}>
        <Container maxWidth="sm">
          <Grid container spacing={3}>
            <Grid item xs={12}>
              <TextField
                type="number"
                label="ID"
                name="id"
                value={state.id}
                onChange={handleChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <FormControlLabel
                control={
                  <Checkbox
                    name="isEvent"
                    checked={state.isEvent}
                    onChange={handleChange}
                  />
                }
                label="Is Event Ticket"
              />
              <FormControlLabel
                control={
                  <Checkbox
                    name="isService"
                    checked={state.isService}
                    onChange={handleChange}
                  />
                }
                label="Is Event Service"
              />
              <FormControlLabel
                control={
                  <Checkbox
                    name="isExperiencePOAP"
                    checked={state.isExperiencePOAP}
                    onChange={handleChange}
                  />
                }
                label="Is POAP Experience"
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                type="text"
                label="Name"
                name="name"
                value={state.name}
                onChange={handleChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                type="text"
                label="Category"
                name="category"
                value={state.category}
                onChange={handleChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                multiline
                rows={4}
                label="Description"
                name="description"
                value={state.description}
                onChange={handleChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                type="text"
                label="Location"
                name="location"
                value={state.location}
                onChange={handleChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                type="date"
                label="Date"
                name="date"
                value={state.date}
                onChange={handleChange}
                fullWidth
                InputLabelProps={{
                  shrink: true,
                }}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                type="text"
                label="Additional dates (separated by commas)"
                name="dates"
                value={state.dates.join(',')}
                onChange={handleChange}
                fullWidth
                helperText="Example: 2023-04-01,2023-04-02,2023-04-03"
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                type="text"
                label="Available hours (separated by commas)"
                name="availableHours"
                value={state.availableHours.join(',')}
                onChange={handleChange}
                fullWidth
                helperText="Example: 9,14,18"
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                type="number"
                label="Mechandise Quantity"
                name="merchandiseQuantity"
                value={state.merchandiseQuantity}
                onChange={handleChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                        type="text"
                        label="IPFS Photo Hash"
                        name="ipfsPhotoHash"
                        value={state.ipfsPhotoHash}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="text"
                        label="IPFS Video Hash"
                        name="ipfsVideoHash"
                        value={state.ipfsVideoHash}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="number"
                        label="Cancellation period (in days)"
                        name="cancellationPeriod"
                        value={state.cancellationPeriod}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="number"
                        label="Expiration time (in days)"
                        name="expirationTime"
                        value={state.expirationTime}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <FormControlLabel
                        control={
                          <Checkbox
                            name="resellable"
                            checked={state.resellable}
                            onChange={handleChange}
                          />
                        }
                        label="Resale Allowed"
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="number"
                        label="Min Price"
                        name="minPrice"
                        value={state.minPrice}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="number"
                        label="Max Price"
                        name="maxPrice"
                        value={state.maxPrice}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <FormControlLabel
                        control={
                          <Checkbox
                            name="refunded"
                            checked={state.refunded}
                            onChange={handleChange}
                          />
                        }
                        label="Refundable"
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="text"
                        label="Streaming Platform"
                        name="streamingPlatform"
                        value={state.streamingPlatform}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="number"
                        label="Ticket Price"
                        name="ticketPrice"
                        value={state.ticketPrice}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="number"
                        label="Max. Tickets"
                        name="maxTickets"
                        value={state.maxTickets}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="number"
                        label="Rating"
                        name="rating"
                        value={state.rating}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        multiline
                        rows={4}
                        label="Review"
                        name="review"
                        value={state.review}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="text"
                        label="Virtual Location"
                        name="virtualLocation"
                        value={state.virtualLocation}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="text"
                        label="Currency"
                        name="currency"
                        value={state.currency}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="text"
                        label="Authenticity Certificate"
                        name="authenticityCertificate"
                        value={state.authenticityCertificate}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
                      <TextField
                        type="text"
                        label="QR Code"
                        name="qrCode"
                        value={state.qrCode}
                        onChange={handleChange}
                        fullWidth
                      />
                    </Grid>
                    <Grid item xs={12}>
            <TextField
              type="number"
              label="Total Tickets Sold"
              name="totalTicketsSold"
              value={state.totalTicketsSold}
              onChange={handleChange}
              fullWidth
            />
          </Grid>
          <Grid item xs={12}>
            <Button
              variant="contained"
              color="primary"
              type="submit"
            >
              Create Experience
            </Button>
          </Grid>
        </Grid> {/* Agregar la etiqueta de cierre faltante */}
      </Container>
    </form>
  </div>
);
}
export default CreateExperience;
                      
