import React from 'react';
import { Link } from 'react-router-dom';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import IconButton from '@mui/material/IconButton';
import MenuIcon from '@mui/icons-material/Menu';
import MenuItem from '@mui/material/MenuItem';
import Menu from '@mui/material/Menu';
import Typography from '@mui/material/Typography';

const AppNavbar = () => {
  const [anchorEl, setAnchorEl] = React.useState(null);
  const open = Boolean(anchorEl);

  const handleMenu = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  return (
    <AppBar position="static" color="default">
      <Toolbar>
        <Typography variant="h6" component={Link} to="/" style={{ flexGrow: 1, textDecoration: 'none' }}>
          TicketSafe
        </Typography>
        <IconButton edge="end" color="inherit" aria-label="menu" onClick={handleMenu}>
          <MenuIcon />
        </IconButton>
        <Menu anchorEl={anchorEl} open={open} onClose={handleClose} MenuListProps={{ 'aria-labelledby': 'basic-button' }}>
          <MenuItem component={Link} to="/create-experience" onClick={handleClose}>Create Experience</MenuItem>
          <MenuItem component={Link} to="/buy-ticket" onClick={handleClose}>Buy Ticket</MenuItem>
          <MenuItem component={Link} to="/confirm-attendance" onClick={handleClose}>Confirm Attendace</MenuItem>
          <MenuItem component={Link} to="/withdraw-funds" onClick={handleClose}>Withdraw Funds</MenuItem>
          <MenuItem component={Link} to="/wallet" onClick={handleClose}>Wallet</MenuItem>
        </Menu>
      </Toolbar>
    </AppBar>
  );
};

export default AppNavbar;
