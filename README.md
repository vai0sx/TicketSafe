# TicketSafe
NFT Ticket MarketPlace for Event Tickets and Event Services

<img width="1279" alt="image" src="https://user-images.githubusercontent.com/130502134/233250791-593ea494-c5c0-4ca2-aa79-983a0868afdc.png">

<img width="1279" alt="image" src="https://user-images.githubusercontent.com/130502134/233250906-9c437f61-993e-4c29-9b40-e4a0d717e015.png">

# TicketSafe

TicketSafe is a decentralized platform for event ticketing and booking, built on the Ethereum blockchain using Solidity. The platform allows users to create events and event services, buy and sell tickets and services, and validate attendance with POAP and Authenticity Certificates.

# Features

+ Create events with customizable parameters such as date, location, and ticket prices.
+ Support for different types of events, including physical, virtual, and hybrid.
+ Create seat types for events, allowing for different pricing tiers.
+ Buy tickets using ERC20 tokens (Ether and USDT).
+ Attendance validation using POAP and Authenticity Certificates.
+ Commission-based revenue sharing for the platform owner.
+ Reselling and refund options for tickets and services.

# Contracts

TicketSafe.sol: The main contract, which handles event creation, ticket sales, attendance validation, and revenue management.

AuthenticityCertificateTickets.sol: A contract that handles issuing Authenticity Certificates for ticket purchases.

IPOAP.sol: An interface for interacting with the POAP contract, allowing for attendance validation using POAP tokens.

# Prerequisites

Solidity ^0.8.19
OpenZeppelin Contracts

# Installation

+ Clone the repository.
+ Install dependencies using npm install.
+ Compile the contracts using truffle compile.
+ Deploy the contracts using truffle migrate.

# Usage

# Creating an Event:
Call the createExperience function with the following parameters:

_isEvent: Set to true if the experience is an event.
_isService: Set to true if the experience is a service.
_isExperiencePOAP: Set to true if the experience should issue POAP tokens for attendance validation.
_name: The name of the event.
_date: The date of the event.
_ticketPrice: The price of the tickets.
_maxTickets: The maximum number of tickets available.
_numRows: The number of rows in the seating area.
_numColumns: The number of columns in the seating area.

# Buying a Ticket
Call the buyTicketERC20 function with the following parameters:

experienceId: The ID of the event.
_ticketId: The ID of the ticket.
_seatTypeId: The ID of the seat type.
_row: The row number of the seat.
_column: The column number of the seat.
token: The ERC20 token to use for payment (Ether or USDT).

# Confirming Attendance
Call the confirmAttendance function with the following parameters:

experienceId: The ID of the event.
Withdrawing Event Revenue
Call the withdraw function with the following parameters:
experienceId: The ID of the event.

# License

TicketSafe is released under the MIT License.

# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.\
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can't go back!**

If you aren't satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you're on your own.

You don't have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn't feel obligated to use this feature. However we understand that this tool wouldn't be useful if you couldn't customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: [https://facebook.github.io/create-react-app/docs/code-splitting](https://facebook.github.io/create-react-app/docs/code-splitting)

### Analyzing the Bundle Size

This section has moved here: [https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size](https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size)

### Making a Progressive Web App

This section has moved here: [https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app](https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app)

### Advanced Configuration

This section has moved here: [https://facebook.github.io/create-react-app/docs/advanced-configuration](https://facebook.github.io/create-react-app/docs/advanced-configuration)

### Deployment

This section has moved here: [https://facebook.github.io/create-react-app/docs/deployment](https://facebook.github.io/create-react-app/docs/deployment)

### `npm run build` fails to minify

This section has moved here: [https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify](https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify)
