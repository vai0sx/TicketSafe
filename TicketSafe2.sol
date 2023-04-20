// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Estructura para almacenar información sobre un usuario
struct User {
    uint256 userId;
    string name;
    string email;
    string birthdate;
    string gender;
    string location;
    string[] phoneNumbers;
    string[] addresses;
    uint256[] rewardPoints;
    uint256[] loyaltyPoints;
    uint256[] purchaseHistory;
    uint256[] pastPurchases;
}

struct EventData {
    string name;
    uint256 date;
    string location;
    uint256 capacity;
    uint256 ticketCount;
    uint256 availableTickets;
    uint256 soldTickets;
    uint256 merchandiseQuantity;
    uint256 sellCount;
    uint256 sellLimit;
    // Propietario del evento
    address owner;
    // Bandera para indicar si el evento está pendiente de verificación
    bool pendingVerification;
    uint256[] ticketIds;
    bool canBid;
    address[] guestList; // Lista de invitados
    string ipfsPhotoHash; // Dirección de la foto en IPFS
    string ipfsVideoHash; // Dirección del video en IPFS
    uint256 cancellationPeriod; // Período de cancelación del evento
    string streamingPlatform; // Plataforma de streaming
    uint256 startTime; // Hora de inicio del evento en línea
    uint256 endTime; // Hora de finalización del evento en línea
    uint256 rating;
    string review;
    // Nueva información para la ubicación en el metaverso
    string virtualLocation; // Nombre de la ubicación virtual
    uint256 virtualLongitude; // Longitud virtual
    uint256 virtualLatitude; // Latitud virtual
    string avatarId;
    string currency;
    string hardwareRequirements;
    string accessMode;
    bool isOnline;
    bool isPhysical;
    bool isMetaverso;
    string VRARData;
}

struct Merchandise {
    uint256 eventId;
    string name;
    string description;
    uint256 price;
    uint256 quantity;
    string ipfsPhotoHash;
    string ipfsVideoHash;
    bool isVirtual;
    bool isActive; // add isActive property
    address organizerId;
}

struct MerchandisePurchase {
    string name;
    string description;
    uint256 eventId;
    uint256 merchandiseId;
    address buyer;
    uint256 quantity;
}

// Estructura para almacenar la información para patrocinadores de merchandise
struct MerchandiseSponsor {
    uint merchandiseId;
    uint sponsorId;
}

// Estructura de datos para el Servicio de Eventos
struct EventServiceData {
string name; // 
string category; // 
string description; // 
uint256[] dates; // 
uint256[] availableHours; 
uint256 ticketCount; 
uint256 availableTickets; 
// Propietario del servicio de evento
address owner;
// Bandera para indicar si el servicio de evento está pendiente de verificación
bool pendingVerification;
// IDs de los tickets asignados al servicio
uint256[] ticketIds;
// Bandera para indicar si se permite la puja por el ticket
bool canBid;
// Lista de invitados
address[] guestList; 
// Dirección de la foto en IPFS
string ipfsPhotoHash;
// Dirección del video en IPFS
string ipfsVideoHash;
string streamingPlatform;
uint256 startTime;
uint256 endTime;
uint256 rating;
string review;
string virtualLocation; 
uint256 virtualLongitude; 
uint256 virtualLatitude; 
string avatarId;
string currency;
string hardwareRequirements;
string accessMode;
bool isOnline;
bool isPhysical;
bool isMetaverso;
string VRARData;
}

// Estructura para almacenar información de los tickets
struct Ticket {
    address owner;
    uint256 eventId;
    uint256 serviceId;
    bool delivered;
    uint256 price;
}

// Estructura de datos para los asientos
struct Seat {
    uint rows; // Fila del asiento
    uint columns; // Columna del asiento
    bool occupied; // Indica si el asiento está ocupado
    uint ticketId; // ID del ticket asociado al asiento
}

// Estructura de datos para el tipo de asiento
struct SeatType {
    string seat_type; // Nombre del tipo de asiento (General, VIP, etc.)
    uint id; // ID del asiento
    bool available; // Indica si el asiento está disponible para la compra
    address owner; // Propietario del asiento
}

// Estructura de datos para los tickets de evento
struct EventTicket {
    string name; // Nombre del evento
    uint256 price; // Precio del ticket
    address owner; // Propietario del ticket
    uint256 expirationTime; // Tiempo de expiración del ticket
    bool auctionAllowed; // Indica si se permite la puja por el ticket
    bool resellable; // Indica si el ticket es reutilizable
    uint minPrice; // Precio mínimo permitido para reventa
    uint maxPrice; // Precio máximo permitido para reventa
    uint256 sellCount;
    uint256 sellLimit;
    bool refunded; // Indica si el ticket ha sido reembolsado
    uint purchaseTime; // Tiempo de compra del ticket
    uint256 cancellationPeriod; // Período de cancelación del ticket
    address authenticityCertificate; // Dirección del certificado de autenticidad
    bytes32 qrCode; // Código QR del ticket
    bytes32 certificate; // Certificado de autenticidad del ticket
    Seat[] seats; // Arreglo de asientos asociados al ticket
    SeatType[] seatTypes; // Arreglo de tipos de asiento asociados al ticket
    uint256 eventId; // ID del evento asociado al ticket
    uint256 availableSeats; // Cantidad de asientos disponibles para la selección
    bool isVirtual; // Indica si el ticket es para una entrada virtual
    POAPEventTicket poap;
    address seller;
}

// Estructura de datos para los tickets de servicio
struct ServiceTicket {
    string name; // Nombre del servicio
    string tipo_reserva;
    uint256 price; // Precio del ticket
    address owner; // Propietario del ticket
    uint256 expirationTime; // Tiempo de expiración del ticket
    bool auctionAllowed; // Indica si se permite la puja por el ticket
    bool resellable; // Indica si el ticket es reutilizable
    uint minPrice; // Precio mínimo permitido para reventa
    uint maxPrice; // Precio máximo permitido para reventa
    uint256 sellCount;
    uint256 sellLimit;
    bool refunded; // Indica si el ticket ha sido reembolsado
    uint purchaseTime; // Tiempo de compra del ticket
    uint256 cancellationPeriod; // Período de cancelación del ticket
    address authenticityCertificate; // Dirección del certificado de autenticidad
    bytes32 qrCode; // Código QR del ticket
    bytes32 certificate; // Certificado de autenticidad del ticket
    uint256 serviceId; // ID del servicio asociado al ticket
    bool isVirtual; // Indica si el ticket es para una entrada virtual
    POAPServiceTicket poap;
    address seller;
}

// Estructura para almacenar la información de una subasta de un ticket de evento
struct Auction {
  uint256 startingPrice;
  uint256 currentPrice;
  address highestBidder;
  uint256 highestBid;
  uint256 endingTime;
}


// Estructura para almacenar la información de los patrocinadores
struct Sponsor {
  uint256 id;
  // Nombre del patrocinador
  string name;
  // URL del sitio web del patrocinador
  string website;
  // Descripción del patrocinador
  string description;
  // Porcentaje de descuento que ofrece el patrocinador
  uint discountPercentage;
  bool isActive;
  uint balance;
}

// Estructura para almacenar la información para eventos patrocinados
struct SponsoredEventTicket {
    uint eventTicketId;
    uint sponsorId;
    uint discountAmount;
    bool isDiscountApplied;
}

// Estructura para almacenar la información para servicios patrocinados
struct SponsoredServiceTicket {
    uint eventServicetId;
    uint sponsorId;
    uint discountAmount;
    bool isDiscountApplied;
}

// Declaración de la estructura para la búsqueda y filtrado
struct SearchFilter {
    string name; // Nombre del evento o servicio
    string location; // Ubicación del evento o servicio
    uint256 startDate; // Fecha de inicio del evento o servicio
    uint256 endDate; // Fecha de finalización del evento o servicio
    uint256 minCapacity; // Capacidad mínima del evento
    uint256 maxCapacity; // Capacidad máxima del evento
    bool isVerified; // Indica si el evento o servicio está verificado
    bool canBid; // Indica si el evento o servicio permite la puja por el ticket
}

// Estructura para un ticket de soporte
struct SupportTicket {
uint id;
address user;
string issue;
SupportStatus status;
uint timestamp;
address agent;
}

// Enumeración para los estados posibles de un ticket de soporte
enum SupportStatus {
Open,
Assigned,
Resolved
}

  struct Scene {
        uint id;
        string name;
        string[] objects;
        string[] characters;
    }

   // Declara la estructura para almacenar información sobre personajes
struct Character {
    uint id;
    string name;
    string description;
    uint256 level;
}

struct Object {
    uint id;
    string name;
    string appearance;
    string[] actions;
    uint256 value;
}

    // Declara los tipos enumerados para describir la apariencia y las acciones de los objetos
    enum Appearance {
        Shiny,
        Dull,
        Rusty
    }

    enum Action {
        Pickup,
        Drop,
        Use
    }

struct Itinerary {
    uint256 itineraryId;
    uint256 eventId;
    string eventName;
    string eventLocation;
    uint256 startTime;
    uint256 endTime;
    string[] items;
}

struct ServiceItinerary {
uint256 serviceId;
string serviceName;
string serviceLocation;
uint256 startTime;
uint256 endTime;
string[] serviceItems;
}

struct POAPEventTicket {
    string name; // Nombre del POAP
    string symbol; // Símbolo del POAP
    uint256 supply; // Suministro total del POAP
    uint256 eventId; // ID del evento asociado
    string imageHash; // Hash de la imagen del POAP
    string description; // Descripción del POAP
    address owner; // Propietario del POAP (creador del evento)
    bool assigned; // Indica si el POAP ha sido asignado o no
}

struct POAPServiceTicket {
    string name; // Nombre del POAP
    string symbol; // Símbolo del POAP
    uint256 supply; // Suministro total del POAP
    uint256 serviceId; // ID del evento asociado
    string imageHash; // Hash de la imagen del POAP
    string description; // Descripción del POAP
    address owner; // Propietario del POAP (creador del evento)
    bool assigned; // Indica si el POAP ha sido asignado o no
}

 struct Coupon {
        uint256 id;
        string code;
        uint256 discountPercentage;
        uint256 expirationTime;
        bool isActive;
    }

struct UserRewards {
        uint256 points;
        uint256 lastEventAttended;
        uint256 lastServiceAttended;
    }

    // Estructura de datos para almacenar las recompensas disponibles
struct Reward {
    string name;
    string description;
    uint256 pointsCost;
}

struct LastMinuteServiceTicket {
    uint256 serviceId;
    uint256 ticketId;
    address seller;
    uint256 price;
    bool isSold;
    address buyer;
}

struct LastMinuteEventTicket {
    uint256 eventId;
    uint256 ticketId;
    address seller;
    uint256 price;
    bool isSold;
    address buyer;
}

// Contrato principal para el Marketplace
contract TicketSafe2 is ERC721 {
constructor() ERC721("TicketSafe", "TS") {}
mapping(address => bool) public isRegistered;
event UserRegistered(address indexed user);
mapping(address => string) public userNames;
event UserNameObtained(address indexed userAddress, string name);
mapping(address => string) private userEmails;
event UserEmailUpdated(address indexed userAddress, string email);
mapping(address => bool) private authenticatedAccounts;
event UserAuthenticated(address indexed userAddress);
mapping(address => bytes32) private userHashes;
mapping(address => bytes32[]) private usedPasswords;
event PasswordUsed(address indexed userAddress, bytes32 passwordHash);
mapping(address => bool) private inProgress;
// Mapeo para almacenar los eventos
mapping(uint256 => EventData) public events;
event EventDataAdded(uint256 indexed eventId, address indexed creator);
mapping (uint256 => EventServiceData) public services;
event EventServiceDataAdded(uint256 indexed serviceId, address indexed creator);
mapping(address => User) public userProfiles;
event UserProfileCreated(address indexed userAddress, string birthdate, string gender, string location);
event UserProfileUpdated(address indexed userAddress, string name, string email, string bio);
EventTicket[] eventTickets;
event EventTicketCreated(uint256 indexed eventId, address indexed creator);
ServiceTicket[] serviceTickets;
event ServiceTicketCreated(uint256 indexed serviceId, address indexed creator);
mapping (uint => bool) public auctionStarted;
event AuctionStarted(uint auctionId);
mapping (uint => Auction) public auctions;
event EventAuctionCreated(uint256 indexed auctionId, address indexed seller, uint256 reservePrice);
event ServiceAuctionCreated(uint256 indexed auctionId, address indexed seller, uint256 startingPrice, uint256 endingTime);
mapping(uint => bool) public eventTicketAssigned;
event TicketAssigned(uint indexed ticketId);
mapping(uint => uint[]) serviceTicketIds;
event ServiceTicketsSigned(uint indexed serviceId, uint[] ticketIds);
mapping(uint256 => uint256) public eventRatings;
event EventRated(uint256 indexed eventId, address indexed rater, uint256 rating);
mapping(uint256 => string) public eventReviews;
event EventReviewed(uint256 indexed eventId, address indexed reviewer, string review);
mapping(uint256 => uint256) public serviceRatings;
event ServiceRated(uint256 indexed serviceId, address indexed rater, uint256 rating);
mapping(uint256 => string) public serviceReviews;
event ServiceReviewed(uint256 indexed serviceId, address indexed reviewer, string review);
// Mapeo para las calificaciones de los servicios
mapping(uint256 => Sponsor) public sponsors;
event SponsorAdded(uint256 indexed sponsorId, address indexed sponsorAddress, string name, string website);
mapping (uint => SponsoredEventTicket) public sponsoredEventTickets;
event SponsoredEventTicketAdded(uint indexed eventTicketId, uint sponsorId);
mapping(uint => SponsoredServiceTicket) public sponsoredServiceTickets;
event SponsoredServiceTicketAdded(uint indexed serviceTicketId, uint sponsorId);
mapping(address => uint256) public organizerBalances;
mapping (uint256 => bool) refundedTickets;
event TicketRefunded(uint256 indexed ticketId, address indexed owner);
mapping (uint256 => bool) refundedServiceTickets;
event ServiceTicketRefunded(uint256 indexed ticketId, address indexed owner);
mapping (uint256 => EventData) public allEvents;
mapping (uint256 => EventServiceData) public allEventServices;
mapping (address => uint) keys;
mapping (uint256 => mapping(uint256 => Merchandise)) public merchandise;
event MerchandiseAdded(uint256 indexed eventId, uint256 indexed merchandiseId, string name, uint256 price, uint256 quantity);
mapping (uint256 => uint256) public totalMerchandise;
event MerchandisePurchased(uint256 indexed merchandiseId, address indexed buyer, uint256 quantity, uint256 totalPrice);
mapping(uint256 => uint256) public totalMerchandisePurchases;
event TotalMerchandiseUpdated(uint256 indexed eventId, uint256 total);
mapping(uint256 => MerchandisePurchase) public merchandisePurchases;
event MerchandisePurchaseMade(uint256 indexed purchaseId, uint256 merchandiseId, address indexed buyer, uint256 quantity, uint256 totalPrice);
mapping(uint256 => Merchandise) public merchandiseList;
mapping(uint256 => MerchandiseSponsor) public merchandiseSponsors;
event MerchandiseSponsored(uint256 indexed merchandiseId, uint256 sponsorId, uint256 price);
mapping(string => string) public validatedTickets;
event TicketValidated (string ticketId, string eventId);
mapping(string => string) public validatedServiceTickets;
event ServiceTicketValidated(string ticketId, string serviceId);
mapping (uint256 => mapping(uint => bool)) public eventSeats;
event EventSeatsChosen(uint256 eventId, uint[] seatRow, uint[] seatColumn);
mapping (uint => SupportTicket) supportTickets;
event SupportTicketCreated(uint indexed ticketId, address indexed creator, string message, uint createdAt);
mapping (uint256 => Scene) public scenes;
event SceneAdded(uint256 indexed sceneId, string name, string description, uint256 capacity); 
mapping (uint256 => Character) public characters;
event CharacterAdded(uint256 indexed characterId, string name, string description, uint256 level);
mapping (uint256 => Object) public objects;
event ObjectAdded(uint256 indexed objectId, string name, string description, uint256 value);
mapping(uint256 => Itinerary) public eventItinerary;
event ItineraryAdded(uint256 indexed eventId, uint256 indexed itineraryId, string name, string[] items);
mapping (uint256 => ServiceItinerary) public serviceItinerary;
event ServiceItineraryAdded(uint256 indexed serviceId, uint256 indexed itineraryId);
mapping (uint256 => POAPEventTicket) public poaps;
event POAPEventTicketAdded(uint256 indexed eventId, uint256 indexed ticketId, string name);
event POAPServiceTicketAdded(uint256 indexed ticketId, uint256 indexed poapId, string name);
mapping(uint256 => Coupon) public coupons;
event CouponCreated(uint256 indexed couponId, string code, uint256 discountPercentage, uint256 expirationTime);
mapping(string => uint256) public couponIdsByCode;
event CouponRedeemed(uint256 indexed couponId, address indexed user);
mapping(address => UserRewards) public userRewards;
event UserRewardUpdated(address indexed user, uint256 newReward);
mapping(address => uint256[]) public userOwnedTickets;
event UserTicketsUpdated(address indexed user, uint256[] newTicketIds);
mapping(address => uint256[]) public userOwnedServiceTickets;
event UserServiceTicketsUpdated(address indexed user, uint256[] newTicketIds);
Reward[] public rewards; // Array de recompensas disponibles
event RewardRedeemed(address indexed user, uint256 rewardId);
mapping(uint256 => mapping(uint256 => LastMinuteEventTicket)) public lastMinuteEventTickets;
event LastMinuteEventTicketSold(uint256 indexed eventId, uint256 indexed ticketId, address indexed seller, uint256 price);
mapping(uint256 => uint256) public totalLastMinuteEventTickets;
event LastMinuteEventTicketPurchased(uint256 indexed eventId, uint256 indexed ticketId, address indexed buyer, uint256 price);
mapping(uint256 => mapping(uint256 => LastMinuteServiceTicket)) public lastMinuteServiceTickets;
event LastMinuteServiceTicketSold(uint256 indexed serviceId, uint256 indexed ticketId, address indexed seller, uint256 price);
mapping(uint256 => uint256) public totalLastMinuteServiceTickets;
event LastMinuteServiceTicketPurchased(uint256 indexed serviceId, uint256 indexed ticketId, address indexed buyer, uint256 price);

// Método para autenticar cuentas de Ethereum
    function authenticate(address _account) public {
        // Verificar que la cuenta del remitente esté autenticada
        require(authenticatedAccounts[msg.sender], "Cuenta no autenticada");
        // Autenticar la cuenta especificada
        authenticatedAccounts[_account] = true;
    }

// Implementa la función para registrar a un usuario
function registerUser(string memory name, string memory email) public {
    // Verifica que el usuario no esté ya registrado
    require(!isRegistered[msg.sender], "User is already registered");

    // Establece el nombre y correo electrónico del usuario
    userNames[msg.sender] = name;
    userEmails[msg.sender] = email;

    // Establece la bandera de isRegistered para el usuario
    isRegistered[msg.sender] = true;

    // Emitir el evento UserRegistered
    emit UserRegistered(msg.sender);
}

    // Implementa la función para obtener una cuenta
    function getAccounts() public view returns (address[] memory) {
        address[] memory accounts = new address[](1);
        accounts[0] = msg.sender;
        return accounts;
    }

    // Implementa la función para autenticar a un usuario
    function authenticateUser() public {
        // Verificar que la dirección de Ethereum que llama a la función esté registrada
        require(isRegistered[msg.sender], "User is not registered");
        // Verificar que la dirección de Ethereum que llama a la función tenga sesión abierta en Metamask
        address[] memory accounts = getAccounts();
        require(accounts.length > 0, "User is not signed in to MetaMask");
        require(accounts[0] == msg.sender, "User is signed in to a different account in MetaMask");
        // Autenticar al usuario
        authenticatedAccounts[msg.sender] = true;

         emit UserAuthenticated(msg.sender);
    }

    // Implementa la función para obtener el nombre de un usuario
    function getUserName(address user) public view returns (string memory) {
        // Verifica que el usuario esté registrado
        require(isRegistered[user], "User is not registered");
        // Devuelve el nombre del usuario
        return userNames[user];
    }

// Función para establecer el correo electrónico de un usuario
function setUserEmail(string memory email) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "User is not authenticated");
    
    // Establece el correo electrónico del usuario
    userEmails[msg.sender] = email;
    
    // Emite el evento UserEmailUpdated
    emit UserEmailUpdated(msg.sender, email);
}

// Función para obtener el correo electrónico de un usuario
function getUserEmail(address user) public view returns (string memory) {
    // Verifica que el usuario esté registrado
    require(isRegistered[user], "User is not registered");
    
    // Devuelve el correo electrónico del usuario
    return userEmails[user];
}
    
// Implementa la función para establecer la contraseña de autenticación de un usuario
    function setAuthenticationPassword(string memory password) public {
        // Verifica que la contraseña proporcionada tenga al menos 8 caracteres
        require(bytes(password).length >= 8, "Password must have at least 8 characters");
        // Verifica que la contraseña proporcionada cumpla con los requisitos de seguridad mínimos
        require(hasMinimumSecurityRequirements(password), "Password does not meet minimum security requirements");
        // Verifica que la contraseña no haya sido utilizada anteriormente por el usuario
        require(!passwordWasPreviouslyUsed(password), "Password was previously used");
        // Verifica que el usuario no esté intentando establecer su contraseña mientras ya está en curso alguna función sensible
        require(!inProgress[msg.sender], "Cannot set password while a sensitive function is in progress");
        // Encripta la contraseña proporcionada antes de almacenarla
        bytes memory passwordBytes = bytes(password);
        bytes32 passwordHash = sha256(passwordBytes);
        // Almacena el hash de la contraseña para el usuario actual
        userHashes[msg.sender] = passwordHash;
        // Agrega la contraseña al mapeo de contraseñas utilizadas por el usuario
        usedPasswords[msg.sender].push(passwordHash);
    }

function changeAuthenticationPassword(string memory currentPassword, string memory newPassword) public {
        // Verifica que el usuario proporcione la contraseña actual correcta
        require(verifyAuthentication(msg.sender, currentPassword), "Invalid current password");
        // Verifica que la nueva contraseña tenga al menos 8 caracteres
        require(bytes(newPassword).length >= 8, "New password must have at least 8 characters");
        // Verifica que la nueva contraseña cumpla con los requisitos de seguridad mínimos
        require(hasMinimumSecurityRequirements(newPassword), "New password does not meet minimum security requirements");
        // Verifica que la nueva contraseña no haya sido utilizada anteriormente por el usuario
        require(!passwordWasPreviouslyUsed(newPassword), "New password was previously used");
        // Encripta la nueva contraseña antes de almacenarla
        bytes memory newPasswordBytes = bytes(newPassword);
        bytes32 newPasswordHash = sha256(newPasswordBytes);
        // Establece el nuevo hash de la contraseña para el usuario
        userHashes[msg.sender] = newPasswordHash;
        // Agrega la nueva contraseña al mapeo de contraseñas utilizadas por el usuario
        usedPasswords[msg.sender].push(newPasswordHash);

        // Emite el evento PasswordUsed
        emit PasswordUsed(msg.sender, newPasswordHash);
    }

    // Implementa la función para verificar la contraseña de autenticación de un usuario
    function verifyAuthentication(address user, string memory password) private view returns (bool) {
        // Encripta la contraseña proporcionada
        bytes memory passwordBytes = bytes(password);
        bytes32 passwordHash = sha256(passwordBytes);
        // Verifica si el hash de la contraseña proporcionada coincide con el almacenado para el usuario
        return userHashes[user] == passwordHash;
    }
         // Protege contra ataques de reentrada
    function someSensitiveFunction() public {
        // Verifica que la función no esté siendo reentrada
        require(!inProgress[msg.sender], "Function is already in progress");
        // Establece la bandera de inProgress para el usuario actual
        inProgress[msg.sender] = true;
        // ... realiza la lógica de la función ...
        // Limpia la bandera de inProgress para el usuario actual al finalizar
        delete inProgress[msg.sender];
    }

    // Implementa una función auxiliar para verificar si la contraseña cumple con ciertos requisitos de seguridad
    function hasMinimumSecurityRequirements(string memory password) private pure returns (bool) {
        bool hasUppercase = false;
        bool hasLowercase = false;
        bool hasNumber = false;
        for (uint i = 0; i < bytes(password).length; i++) {
            if (bytes(password)[i] >= 'A' && bytes(password)[i] <= 'Z') {
                hasUppercase = true;
            } else if (bytes(password)[i] >= 'a' && bytes(password)[i] <= 'z') {
                hasLowercase = true;
            } else if (bytes(password)[i] >= bytes1('0') && bytes(password)[i] <= bytes1('9')) {
                hasNumber = true;
            }
        }
        // Verifica que la contraseña tenga al menos una letra mayúscula, una letra minúscula y un número
        return hasUppercase && hasLowercase && hasNumber;
    }

    // Implementa una función auxiliar para verificar si la contraseña ha sido utilizada previamente por el usuario
    function passwordWasPreviouslyUsed(string memory password) private view returns (bool) {
        // Encripta la contraseña proporcionada
        bytes memory passwordBytes = bytes(password);
        bytes32 passwordHash = sha256(passwordBytes);
        // Verifica si el hash de la contraseña proporcionada se encuentra en el mapeo de contraseñas utilizadas por el usuario
        for (uint i = 0; i < usedPasswords[msg.sender].length; i++) {
            if (usedPasswords[msg.sender][i] == passwordHash) {
                return true;
            }
        }
        return false;
    }

// Función para crear un perfil de usuario
function createUserProfile(string memory birthdate, string memory gender, string memory location) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "User is not authenticated");
    // Verifica que el usuario aún no tenga un perfil creado
    bytes memory b = bytes(userProfiles[msg.sender].birthdate);
    require(b.length == 0, "User profile already exists");
    // Crea un nuevo perfil de usuario
    userProfiles[msg.sender] = User({
        userId: 0,
        name: "",
        email: "",
        birthdate: birthdate,
        gender: gender,
        location: location,
        phoneNumbers: new string[](0),
        addresses: new string[](0),
        rewardPoints: new uint256[](0),
        loyaltyPoints: new uint256[](0),
        purchaseHistory: new uint256[](0),
        pastPurchases: new uint256[](0)
    });

    emit UserProfileCreated(msg.sender, birthdate, gender, location);
}

// Función para actualizar el perfil de usuario
function updateUserProfile(string memory birthdate, string memory gender, string memory location) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "User is not authenticated");
    // Actualiza la información del perfil de usuario
    userProfiles[msg.sender] = User({
        userId: 0,
        name: "",
        email: "",
        birthdate: birthdate,
        gender: gender,
        location: location,
        phoneNumbers: new string[](0),
        addresses: new string[](0),
        rewardPoints: new uint256[](0),
        loyaltyPoints: new uint256[](0),
        purchaseHistory: new uint256[](0),
        pastPurchases: new uint256[](0)
    });

    emit UserProfileUpdated(msg.sender, birthdate, gender, location);
}

// Función para obtener el perfil de usuario
function getUserProfile(address user) public view returns (string memory, string memory, string memory) {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[user], "User is not authenticated");
    // Devuelve la información del perfil de usuario
    User memory profile = userProfiles[user];
    return (profile.birthdate, profile.gender, profile.location);
}

function ownerOf(uint256 eventId) public view override returns (address) {
    return events[eventId].owner;
}

// Función para mostrar un mapa de asientos disponibles y seleccionar asientos específicos
function showSeatMapAndSelectSeats(uint256 _ticketId, uint[] memory selectedSeats) public {
// Verifica que el ID del ticket sea válido
require(_ticketId < eventTicketCount, "ID de ticket invalido");
// Verifica que los asientos seleccionados estén disponibles
for (uint i = 0; i < selectedSeats.length; i++) {
require(eventTickets[_ticketId].seatTypes[selectedSeats[i]].available, "El asiento seleccionado no esta disponible");
}
// Marca los asientos seleccionados como ocupados
for (uint i = 0; i < selectedSeats.length; i++) {
eventTickets[_ticketId].seatTypes[selectedSeats[i]].available = false;
eventTickets[_ticketId].seatTypes[selectedSeats[i]].owner = msg.sender;
eventTickets[_ticketId].seats[selectedSeats[i]].occupied = true;
eventTickets[_ticketId].seats[selectedSeats[i]].ticketId = selectedSeats[i];
}
}

// Función para crear un Evento
uint256 eventCount = 0;

function createEvent(string memory name, uint256 date, string memory location, uint256 capacity, uint256 merchandiseQuantity, uint256 sellLimit, string memory ipfsPhotoHash, string memory ipfsVideoHash, uint256 cancellationPeriod, string memory avatarId, string memory currency, string memory hardwareRequirements, address[] memory guestList, string memory accessMode, bool isOnline, bool isPhysical, bool isMetaverso, string memory vrarData) public {
// Verifica que el usuario esté autenticado
require(authenticatedAccounts[msg.sender], "El usuario no esta autenticado");
// Verifica que el usuario sea el propietario del evento
require(ownerOf(eventCount) == msg.sender, "El usuario no es el propietario del evento");

// Crea un nuevo evento
EventData memory eventData = EventData({
name: name,
date: date,
location: location,
capacity: capacity,
ticketCount: 0,
availableTickets: capacity,
soldTickets: 0,
merchandiseQuantity: merchandiseQuantity,
sellCount: 0,
sellLimit: sellLimit,
owner: msg.sender,
pendingVerification: true,
ticketIds: new uint256[](0),
canBid: false,
ipfsPhotoHash: ipfsPhotoHash,
ipfsVideoHash: ipfsVideoHash,
cancellationPeriod: cancellationPeriod,
streamingPlatform: "",
startTime: 0,
endTime: 0,
rating: 0,
review: "",
virtualLocation: "",
virtualLongitude: 0,
virtualLatitude: 0,
avatarId: avatarId,
currency: currency,
hardwareRequirements: hardwareRequirements,
guestList: guestList,
accessMode: accessMode,
isOnline: isOnline,
isPhysical: isPhysical,
isMetaverso: isMetaverso,
VRARData: vrarData
});
events[eventCount] = eventData;

// Emitir el evento EventDataAdded
emit EventDataAdded(eventCount, msg.sender);
eventCount++;
}

function ownerOfEvent(uint256 eventId) public view returns (address) {
    return events[eventId].owner;
}

function addEventToItinerary(uint256 _eventId, EventData memory _eventData) public {
    Itinerary memory newEvent;
    newEvent.eventId = _eventId;
    newEvent.eventName = _eventData.name;
    newEvent.eventLocation = _eventData.location;
    newEvent.startTime = _eventData.startTime;
    newEvent.endTime = _eventData.endTime;
    eventItinerary[_eventId] = newEvent;

    emit ItineraryAdded(_eventId, newEvent.itineraryId, newEvent.eventName, newEvent.items);
}

function createEventMerchandise(uint256 _eventId, string memory _name, string memory _description, uint256 _price, uint256 _quantity) public {
    // Verificar que la cuenta del remitente esté autenticada y sea el dueño del evento
    require(authenticatedAccounts[msg.sender] && events[_eventId].owner == msg.sender, "Cuenta no autenticada o no es dueno del evento");
    // Verificar que el precio del producto sea mayor a cero
    require(_price > 0, "El precio del producto debe ser mayor a cero");
    // Verificar que la cantidad del producto sea mayor a cero
    require(_quantity > 0, "La cantidad del producto debe ser mayor a cero");
    // Verificar que la cantidad de merchandise disponible sea suficiente
    require(events[_eventId].merchandiseQuantity >= _quantity, "La cantidad de merchandise disponible es insuficiente");

    // Actualizar la cantidad de merchandise disponible
    events[_eventId].merchandiseQuantity -= _quantity;

// Crear un nuevo merchandise
    Merchandise memory newMerchandise = Merchandise({
        eventId: _eventId,
        name: _name,
        description: _description,
        price: _price,
        quantity: _quantity,
        ipfsPhotoHash: "",
        ipfsVideoHash: "",
        isVirtual: false,
        isActive: true,
        organizerId: msg.sender // Almacena la dirección del organizador
    });

    // Agregar el producto de merchandising al almacenamiento
    merchandise[_eventId][totalMerchandise[_eventId]] = newMerchandise;
    totalMerchandise[_eventId]++;

    emit MerchandiseAdded(_eventId, totalMerchandise[_eventId] - 1, _name, _price, _quantity);
}

// Función para comprar merchandise en un evento con criptomonedas
function buyEventMerchandiseWithCryptocurrency(uint256 _eventId, uint256 _merchandiseId, uint256 _quantity, string memory _couponCode) public payable {
    // Verificar que el evento y el merchandise existen
    require(_eventId < totalEvents, "El evento no existe");
    require(merchandise[_eventId][_merchandiseId].eventId == _eventId, "El merchandise no existe para el evento");
    // Verificar que la cantidad solicitada esté disponible
    Merchandise storage m = merchandise[_eventId][_merchandiseId];
    require(m.quantity >= _quantity, "La cantidad de merchandise solicitada no esta disponible");

    uint256 totalCost = m.price * _quantity;
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "El codigo de cupon no existe");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "El cupon no esta activo");
        require(block.timestamp <= coupon.expirationTime, "El cupon ha expirado");

        uint256 discountAmount = (m.price * _quantity * coupon.discountPercentage) / 100;
        totalCost -= discountAmount;
    }

    // Verificar que el monto recibido sea suficiente para cubrir el costo total
    require(msg.value >= totalCost, "El pago enviado no es suficiente para cubrir el costo total");

    // Transferir los fondos al dueño del evento
    address payable eventOwner = payable(events[_eventId].owner);
    eventOwner.transfer(totalCost);

    // Actualizar la cantidad de merchandise disponible
    m.quantity -= _quantity;

    // Registrar la compra de merchandise
    uint256 purchaseId = totalMerchandisePurchases[_eventId]++;
    MerchandisePurchase storage newPurchase = merchandisePurchases[purchaseId];
    newPurchase.name = m.name;
    newPurchase.description = m.description;
    newPurchase.eventId = _eventId;
    newPurchase.merchandiseId = _merchandiseId;
    newPurchase.buyer = msg.sender;
    newPurchase.quantity = _quantity;

    emit MerchandisePurchased(_merchandiseId, msg.sender, _quantity, totalCost);
    emit MerchandisePurchaseMade(purchaseId, _merchandiseId, msg.sender, _quantity, totalCost);
}

// Función para vender merchandise en un evento con criptomonedas
function sellEventMerchandiseWithCryptocurrency(uint256 _eventId, uint256 _merchandiseId, uint256 _priceInWei, address payable commissionWallet) public {
    // Verificar que la cuenta del remitente este autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el evento y el merchandise existan
    require(_eventId < totalEvents, "El evento no existe");
    require(merchandise[_eventId][_merchandiseId].eventId == _eventId, "El merchandise no existe para el evento");
    // Verificar que el merchandise tenga suficiente cantidad disponible
    Merchandise storage m = merchandise[_eventId][_merchandiseId];
    require(m.quantity > 0, "El merchandise no tiene suficiente cantidad disponible");

    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Retener la comisión
    commissionWallet.transfer(commission);

    // Transferir el merchandise al comprador especificado
    safeTransferFrom(address(this), msg.sender, _merchandiseId);
    // Actualizar la cantidad de merchandise disponible
    m.quantity--;

    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de criptomonedas al vendedor (menos la comisión)
    vendorAddress.transfer(_priceInWei - commission);
}

// Función para dejar una reseña y calificación de un evento
function leaveEventReview(uint256 eventId, uint256 rating, string memory review) public {
// Verifica que el usuario esté autenticado
require(authenticatedAccounts[msg.sender], "El usuario no esta autenticado");
// Verifica que el evento exista
require(events[eventId].ticketCount != 0, "Evento no encontrado");
// Verifica que la calificación sea válida (entre 1 y 5)
require(rating >= 1 && rating <= 5, "Calificacion invalida");
// Asigna la calificación y la reseña al evento
eventRatings[eventId] = rating;
eventReviews[eventId] = review;

// Emitir el evento EventRated
    emit EventRated(eventId, msg.sender, rating);

    // Emitir el evento EventReviewed
    emit EventReviewed(eventId, msg.sender, review);
}

// Función para agregar eventos en línea por streaming
function addOnlineEvent(uint256 _eventId, string memory _streamingPlatform, uint256 _startTime, uint256 _endTime) public {
// Verifica que el usuario esté autenticado
require(authenticatedAccounts[msg.sender], "El usuario no esta autenticado");
// Verifica que el ID del evento sea válido
require(_eventId < eventCount, "ID de evento invalido");
// Verifica que el remitente sea el dueño del evento
require(events[_eventId].owner == msg.sender, "No tienes permiso para agregar un evento en linea para este evento");
// Verifica que la plataforma de streaming sea válida
require(validStreamingPlatform(_streamingPlatform), "Plataforma de streaming invalida");
// Verifica que la hora de inicio y finalización sean válidas
require(_startTime < _endTime, "Hora de inicio y finalizacion invalidas");
// Agrega la información de streaming al evento correspondiente
events[_eventId].streamingPlatform = _streamingPlatform;
events[_eventId].startTime = _startTime;
events[_eventId].endTime = _endTime;
}

enum StreamingPlatform {
    Twitch,
    YouTube,
    Facebook
}

function validStreamingEventPlatform(string memory platform) internal pure returns (bool) {
    bytes32 platformHash = keccak256(bytes(platform));
    bytes32 twitchHash = keccak256(bytes("Twitch"));
    bytes32 youtubeHash = keccak256(bytes("YouTube"));
    bytes32 facebookHash = keccak256(bytes("Facebook"));
    return platformHash == twitchHash ||
           platformHash == youtubeHash ||
           platformHash == facebookHash;
}

// Función para Actualizar un Evento
function updateEvent(uint256 _eventId, string memory _name, uint256 _date, string memory _location, uint256 _capacity, uint256 _sellLimit, string memory _ipfsPhotoHash, string memory _ipfsVideoHash, uint256 _cancellationPeriod) public {
    // Verificar que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "El usuario no estA autenticado");
    // Verificar que el ID del evento sea válido
    require(_eventId < eventCount, "ID de evento invalido");
    // Verificar que el remitente sea el dueño del evento
    require(events[_eventId].owner == msg.sender, "No tienes permiso para actualizar este evento");
   // Verificar que el período de cancelación sea válido
   require(_cancellationPeriod >= 0, "Periodo de cancelacion invalido");
   // Actualizar los datos del evento
   events[_eventId].name = _name;
   events[_eventId].date = _date;
   events[_eventId].location = _location;
   events[_eventId].capacity = _capacity;
   events[_eventId].sellLimit = _sellLimit;
   events[_eventId].ipfsPhotoHash = _ipfsPhotoHash;
   events[_eventId].ipfsVideoHash = _ipfsVideoHash;
   events[_eventId].cancellationPeriod = _cancellationPeriod;
}

uint256 eventTicketCount = 0;

// Función para crear un ticket de evento
function createEventTicket(string memory name, uint256 price, uint256 expirationTime, bool auctionAllowed, bool resellable, uint minPrice, uint maxPrice, uint256 cancellationPeriod, address payable authenticityCertificate, uint256 seats, bytes memory qrCode, bytes memory certificate, uint256 sellLimit) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "User is not authenticated");

    POAPEventTicket memory poapEventTicket = POAPEventTicket({
        name: "",
        symbol: "",
        supply: 0,
        eventId: eventCount,
        imageHash: "",
        description: "",
        owner: msg.sender,
        assigned: false
    });

    // Crea un nuevo ticket para el evento
    EventTicket memory eventTicket = EventTicket({
        name: name,
        price: price,
        owner: msg.sender,
        expirationTime: expirationTime,
        auctionAllowed: auctionAllowed,
        resellable: resellable,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sellCount: 0,
        sellLimit: sellLimit,
        refunded: false,
        purchaseTime: block.timestamp,
        cancellationPeriod: cancellationPeriod,
        authenticityCertificate: authenticityCertificate,
        qrCode: bytes32(qrCode),
        certificate: bytes32(certificate),
        availableSeats: seats,
        seats: new Seat[](1), // Inicializa "seats" como un arreglo con un elemento
        seatTypes: new SeatType[](1), 
        eventId: eventTicketCount++, // Asigna un ID único al evento
        isVirtual: false,
        poap: poapEventTicket,
        seller: address(0)
    });

    for (uint i = 0; i < seats; i++) {
        Seat memory seat = Seat({
            rows: i,
            columns: 0,
            occupied: false,
            ticketId: i
        });
        eventTicket.seats[i] = seat;

        SeatType memory seatType = SeatType({
            seat_type: "General",
            id: i,
            available: true,
            owner: address(0)
        });
        eventTicket.seatTypes[i] = seatType;
    }

    // Emitir el evento EventTicketCreated
    emit EventTicketCreated(eventTicketCount - 1, msg.sender);
    emit POAPEventTicketAdded(poapEventTicket.eventId, eventTicketCount - 1, poapEventTicket.name);
}

function confirmAttendanceEvent(uint256 eventId) public {
    // Obtiene el ticket correspondiente al ID del evento
    EventTicket memory eventTicket = eventTickets[eventId];
    // Verifica que el evento tenga al menos un asiento disponible
    require(eventTicket.availableSeats > 0, "No hay asientos disponibles");
    // Verifica que la asistencia se esté confirmando antes de la fecha de vencimiento
    require(block.timestamp <= eventTicket.expirationTime, "El tiempo para confirmar la asistencia ha vencido");
    // Asigna el POAP correspondiente
    POAPEventTicket memory poapEventTicket = eventTicket.poap;
    poapEventTicket.assigned = true;
    // Actualiza la información del ticket de evento
    eventTicket.availableSeats--;
    eventTickets[eventId] = eventTicket;
}

// Función para actualizar un Ticket de Evento
function updateEventTicket(uint256 _ticketId, string memory _name, uint256 _price, uint256 _expirationTime, bool _auctionAllowed, bool _resellable, uint _minPrice, uint _maxPrice, uint256 _cancellationPeriod, address _authenticityCertificate, uint256 _seats, bytes memory _qrCode, bytes memory _certificate) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "El usuario no estA autenticado");
    // Verifica que el ID del ticket sea válido
    require(_ticketId < eventTicketCount, "ID de ticket invalido");
    // Verifica que el remitente sea el propietario del ticket
    require(eventTickets[_ticketId].owner == msg.sender, "No tienes permiso para actualizar este ticket");
    // Actualiza los datos del ticket
    eventTickets[_ticketId].name = _name;
    eventTickets[_ticketId].price = _price;
    eventTickets[_ticketId].expirationTime = _expirationTime;
    eventTickets[_ticketId].auctionAllowed = _auctionAllowed;
    eventTickets[_ticketId].resellable = _resellable;
    eventTickets[_ticketId].minPrice = _minPrice;
    eventTickets[_ticketId].maxPrice = _maxPrice;
    eventTickets[_ticketId].cancellationPeriod = _cancellationPeriod;
    eventTickets[_ticketId].authenticityCertificate = _authenticityCertificate;
    eventTickets[_ticketId].qrCode = bytes32(_qrCode);
    eventTickets[_ticketId].certificate = bytes32(_certificate);
    eventTickets[_ticketId].seats = new Seat[](_seats);
    eventTickets[_ticketId].seatTypes = new SeatType[](_seats);
    for (uint i = 0; i < _seats; i++) {
        Seat memory seat = Seat({
            rows: i,
            columns: 0,
            occupied: false,
            ticketId: i
        });
        eventTickets[_ticketId].seats[i] = seat;

        SeatType memory seatType = SeatType({
            seat_type: "General",
            id: i,
            available: true,
            owner: address(0)
        });
        eventTickets[_ticketId].seatTypes[i] = seatType;
    }
}

function assignEventTicketToEvent(uint eventId, uint ticketId) public {
    // Obtiene el evento correspondiente a la ID proporcionada
    EventData memory eventData = events[eventId];
    // Obtiene el ticket correspondiente a la ID proporcionada
    EventTicket memory eventTicket = eventTickets[ticketId];
    // Verifica que el usuario sea el propietario del evento
    require(eventData.owner == msg.sender, "User is not the owner of the event");
    // Verifica que el ticket pertenezca al usuario
    require(eventTicket.owner == msg.sender, "User does not own the ticket");
    // Verifica que el ticket no haya sido asignado previamente
    require(!eventTicketAssigned[ticketId], "Ticket has already been assigned");
    // Asigna el ticket al evento
    eventTicketAssigned[ticketId] = true;
    eventData.ticketCount++;
    eventData.availableTickets--;

    emit TicketAssigned(ticketId);
}

function startAuction(uint ticketId) public {
  // Obtiene el ticket correspondiente a la ID proporcionada
  EventTicket memory eventTicket = eventTickets[ticketId];
  // Verifica que el ticket permita subastas
  require(eventTicket.auctionAllowed, "Auctions are not allowed for this ticket");
  // Verifica que la subasta no haya comenzado
  require(!auctionStarted[ticketId], "Auction has already started for this ticket");
  // Inicializa la subasta para el ticket
  auctionStarted[ticketId] = true;
  Auction memory auction = Auction({
    startingPrice: eventTicket.price,
    currentPrice: eventTicket.price,
    highestBidder: address(0),
    highestBid: 0,
    endingTime: block.timestamp + 7 days
  });
  auctions[ticketId] = auction;

  // Emitir el evento AuctionCreated con los detalles relevantes
emit EventAuctionCreated(ticketId, eventTicket.owner, auctions[ticketId].endingTime);
}

// Función para hacer una puja en una subasta de un ticket de evento
function bid(uint ticketId, uint256 value) public payable {
  // Obtiene la subasta correspondiente a la ID de ticket proporcionada
  Auction memory auction = auctions[ticketId];
  // Verifica que la subasta haya comenzado
  require(auctionStarted[ticketId], "Auction has not started for this ticket");
  // Verifica que la subasta no haya terminado
  require(block.timestamp <= auction.endingTime, "Auction has ended");
  // Verifica que la puja sea mayor que la puja actual
  require(value > auction.currentPrice, "Bid must be higher than current price");
  // Actualiza la puja actual y el postor con la puja proporcionada
  auction.highestBid = value;
  auction.highestBidder = msg.sender;
  auction.currentPrice = value;
}

// Función para finalizar una subasta de un ticket de evento
function endAuction(uint ticketId) public view {
  // Obtiene la subasta correspondiente a la ID de ticket proporcionada
  Auction memory auction = auctions[ticketId];
  // Verifica que la subasta haya comenzado
  require(auctionStarted[ticketId], "Auction has not started for this ticket");
  // Verifica que la subasta haya terminado
  require(block.timestamp > auction.endingTime, "Auction has not ended");
  // Transfiere el ticket al postor ganador de la subasta
  EventTicket memory eventTicket = eventTickets[ticketId];
  eventTicket.owner = auction.highestBidder;
  }

// Función para Comprar un ticket de evento con criptomonedas
function buyEventTicketWithCryptocurrency(uint256 _ticketId, string memory _couponCode) public payable {
    // Verificar que el ID del ticket sea válido
    require(_ticketId < eventTickets.length, "ID de ticket invalido");
    // Verificar que el ticket no tenga un propietario
    require(eventTickets[_ticketId].owner == address(0), "El ticket ya tiene un propietario");
    // Verificar que el ticket no haya expirado
    require(eventTickets[_ticketId].expirationTime == 0 || eventTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
    uint256 ticketPrice = eventTickets[_ticketId].price;
    uint256 newTicketPrice = ticketPrice;

    // Si se proporciona un código de cupón, aplicar el descuento
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "Coupon code does not exist");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "Coupon is not active");
        require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

        uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;
        newTicketPrice = ticketPrice - discountAmount;
    }

    // Verificar que el monto recibido sea igual al precio del ticket (con descuento, si corresponde)
    require(msg.value == newTicketPrice, "Monto incorrecto");
    // Verificar que el evento tenga asientos disponibles para la compra del ticket
    require(events[eventTickets[_ticketId].eventId].availableTickets > 0, "No hay asientos disponibles para el evento");

    // Transferir el ticket al comprador especificado
    safeTransferFrom(address(0), msg.sender, _ticketId);
    // Actualizar la dirección del propietario del ticket
    eventTickets[_ticketId].owner = msg.sender;

    // Decrementar la cantidad de asientos disponibles para el evento
    events[eventTickets[_ticketId].eventId].availableTickets--;

    // Si se utilizó un cupón, desactivarlo después de su uso
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        coupons[couponId].isActive = false;
        emit CouponRedeemed(couponId, msg.sender);
    }
}
// Función para vender un ticket de evento con criptomonedas
function sellEventTicketWithCryptocurrency(uint256 _ticketId, uint256 _priceInWei, address payable commissionWallet) public payable {
    // Verificar que la cuenta del remitente este autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < eventTickets.length, "ID de ticket invalido");
    // Verificar que el ticket tenga un propietario
    require(eventTickets[_ticketId].owner == msg.sender, "El ticket no tiene propietario");
    // Verificar que el ticket no haya expirado
    require(eventTickets[_ticketId].expirationTime == 0 || eventTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
    // Verificar que el monto recibido sea igual al precio del ticket
    require(msg.value == _priceInWei, "Monto incorrecto");
    // Verificar que el evento tenga asientos disponibles para la compra del ticket
    require(events[eventTickets[_ticketId].eventId].availableTickets > 0, "No hay asientos disponibles para el evento");
    
    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Retener la comisión
    commissionWallet.transfer(commission);
    
    // Transferir el ticket al comprador especificado
    safeTransferFrom(msg.sender, address(this), _ticketId);
    // Actualizar la dirección del propietario del ticket
    eventTickets[_ticketId].owner = address(this);
    
    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de criptomonedas al vendedor (menos la comisión)
    vendorAddress.transfer(msg.value - commission);
    
    // Decrementar la cantidad de asientos disponibles para el evento
    events[eventTickets[_ticketId].eventId].availableTickets--;
}

function buyEventTicketWithStripe(uint256 _ticketId, string memory _couponCode, address payable sellerAddress) public payable {
    // Verificar que el ID del ticket sea válido
    require(_ticketId < eventTickets.length, "ID de ticket invalido");
    // Verificar que el ticket no tenga un propietario
    require(eventTickets[_ticketId].owner == address(0), "El ticket ya tiene propietario");
    // Verificar que el ticket no haya expirado
    require(eventTickets[_ticketId].expirationTime == 0 || eventTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");

    uint256 ticketPrice = eventTickets[_ticketId].price;
    uint256 newTicketPrice = ticketPrice;

    // Si se proporciona un código de cupón, aplicar el descuento
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "Coupon code does not exist");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "Coupon is not active");
        require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

        uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;
        newTicketPrice = ticketPrice - discountAmount;
    }

    // Verificar que el monto recibido sea igual al precio del ticket (con descuento, si corresponde)
    require(msg.value == newTicketPrice, "Monto incorrecto");
    // Verificar que el evento tenga asientos disponibles para la compra del ticket
    require(events[eventTickets[_ticketId].eventId].availableTickets > 0, "No hay asientos disponibles para el evento");

    // Transferir el ticket al comprador especificado
    safeTransferFrom(address(0), msg.sender, _ticketId);
    // Actualizar la dirección del propietario del ticket
    eventTickets[_ticketId].owner = msg.sender;

    // Transferir el monto de Stripe al vendedor
    sellerAddress.transfer(msg.value);

    // Decrementar la cantidad de asientos disponibles para el evento
    events[eventTickets[_ticketId].eventId].availableTickets--;
}

// Función para vender un ticket de evento con Stripe
function sellEventTicketWithStripe(uint256 _ticketId, uint256 _priceInWei, address payable commissionWallet) public {
// Verificar que la cuenta del remitente esté autenticada
require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
// Verificar que el ID del ticket sea válido
require(_ticketId < eventTickets.length, "ID de ticket invalido");
// Verificar que el ticket tenga un propietario
require(eventTickets[_ticketId].owner == msg.sender, "El ticket no tiene propietario");
// Verificar que el ticket no haya expirado
require(eventTickets[_ticketId].expirationTime == 0 || eventTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
// Calcular la comisión de la transacción
uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
// Retener la comisión
commissionWallet.transfer(commission);

// Transferir el ticket al comprador especificado
safeTransferFrom(msg.sender, address(this), _ticketId);
// Actualizar la dirección del propietario del ticket
eventTickets[_ticketId].owner = address(this);

// Crear una dirección pagable a partir de la dirección original
address payable vendorAddress = payable(msg.sender);
// Transferir el monto de criptomonedas al vendedor (menos la comisión)
vendorAddress.transfer(_priceInWei - commission);

// Decrementar la cantidad de asientos disponibles para el evento
events[eventTickets[_ticketId].eventId].availableTickets--;
}

function buyEventTicketWithPayPal(uint256 _ticketId, string memory _couponCode, uint256 _priceInWei, address payable commissionWallet) public payable {
    // Verificar que el ID del ticket sea válido
    require(_ticketId < eventTickets.length, "ID de ticket invalido");
    // Verificar que el ticket no tenga un propietario
    require(eventTickets[_ticketId].owner == address(0), "El ticket ya tiene un propietario");
    // Verificar que el evento asociado al ticket tenga asientos disponibles
    require(events[eventTickets[_ticketId].eventId].availableTickets > 0, "No hay asientos disponibles para este evento");

    uint256 ticketPrice = eventTickets[_ticketId].price;
    uint256 newTicketPrice = ticketPrice;

    // Si se proporciona un código de cupón, aplicar el descuento
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "Coupon code does not exist");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "Coupon is not active");
        require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

        uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;
        newTicketPrice = ticketPrice - discountAmount;
    }

    // Verificar que el precio del ticket sea igual o mayor al precio especificado (con descuento, si corresponde)
    require(newTicketPrice >= _priceInWei, "El precio del ticket es mayor al precio especificado");

    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Transferir la comisión a la dirección especificada
    commissionWallet.transfer(commission);

    // Transferir el ticket al comprador especificado
    safeTransferFrom(address(this), msg.sender, _ticketId);
    // Actualizar la dirección del propietario del ticket
    eventTickets[_ticketId].owner = msg.sender;

    // Crear una dirección pagable a partir de la dirección del comprador
    address payable buyerAddress = payable(msg.sender);
    // Transferir el monto de PayPal desde la dirección del comprador (más la comisión)
    buyerAddress.transfer(_priceInWei + commission);

    // Incrementar la cantidad de asientos vendidos para el evento
    events[eventTickets[_ticketId].eventId].soldTickets++;
}

// Función para vender un ticket de evento con PayPal
function sellEventTicketWithPayPal(uint256 _ticketId, uint256 _priceInWei, address payable commissionWallet) public {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < eventTickets.length, "ID de ticket invalido");
    // Verificar que el ticket tenga un propietario
    require(eventTickets[_ticketId].owner == msg.sender, "El ticket no tiene propietario");
    // Verificar que el ticket no haya expirado
    require(eventTickets[_ticketId].expirationTime == 0 || eventTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Retener la comisión
    commissionWallet.transfer(commission);
    
    // Transferir el ticket al comprador especificado
    safeTransferFrom(msg.sender, address(this), _ticketId);
    // Actualizar la dirección del propietario del ticket
    eventTickets[_ticketId].owner = address(this);
    
    // Incrementar la cantidad de tickets vendidos para el evento
    events[eventTickets[_ticketId].eventId].soldTickets++;
    
    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de PayPal al vendedor (menos la comisión)
    vendorAddress.transfer(_priceInWei - commission);
}

function buyLastMinuteEventTicket(uint256 _eventId, uint256 _ticketId) public payable {
    EventTicket storage eventTicket = eventTickets[_ticketId];

    require(block.timestamp >= eventTicket.expirationTime - 1 hours, "Solo se pueden comprar tickets de ultimo minuto dentro de la ultima hora antes de la expiracion");
    require(eventTicket.owner == address(this), "El ticket debe estar en venta por el contrato");
    require(msg.value == eventTicket.price, "El monto enviado debe ser igual al precio del ticket");

    // Transferir el ticket al comprador
    safeTransferFrom(address(this), msg.sender, _ticketId);
    // Actualizar el propietario del ticket
    eventTicket.owner = msg.sender;

    // Transferir el monto de criptomonedas al vendedor
    address payable vendorAddress = payable(eventTicket.seller);
    uint256 fee = (eventTicket.price * transactionFee) / 100;
    uint256 netPrice = eventTicket.price - fee;
    vendorAddress.transfer(netPrice);

    // Transferir la tarifa al commissionWallet
    address payable commissionWallet = payable(address(uint160(ownerOf(_ticketId))));
    commissionWallet.transfer(fee);

    emit LastMinuteEventTicketPurchased(_eventId, _ticketId, msg.sender, eventTicket.price);
}

uint256 public transactionFee = 35; // Tarifa por transacción en partes por mil (3.5%)

function sellLastMinuteEventTicket(uint256 _eventId, uint256 _ticketId, address payable commissionWallet) public payable {
    EventTicket storage eventTicket = eventTickets[_eventId];
    
    require(eventTicket.owner == msg.sender, "Solo el propietario del ticket puede venderlo");
    require(block.timestamp >= eventTicket.expirationTime - 1 hours, "La venta de ultimo minuto solo es valida dentro de la ultima hora antes de la expiracion");
    
    uint256 fee = (eventTicket.price * transactionFee) / 100;
    uint256 netPrice = eventTicket.price - fee;

    // Verificar que el monto recibido sea igual al precio del ticket
    require(msg.value == eventTicket.price, "Monto incorrecto");
    
    // Retener la comisión
    commissionWallet.transfer(fee);
    
    // Transferir el ticket al comprador especificado
    safeTransferFrom(msg.sender, address(this), _ticketId);
    // Actualizar la dirección del propietario del ticket
    eventTicket.owner = address(this);
    // Asignar el valor del vendedor al campo "seller"
    eventTicket.seller = msg.sender;
    
    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de criptomonedas al vendedor (menos la comisión)
    vendorAddress.transfer(netPrice);

    emit LastMinuteEventTicketSold(_eventId, _ticketId, msg.sender, eventTicket.price);
}

// Método para elegir los asientos de un evento
function chooseEventSeats(uint256 _eventId, uint[] memory _seatRows, uint[] memory _seatColumns) public {
// Verificar que la cuenta del remitente esté autenticada
require(authenticatedAccounts[msg.sender], "Cuenta no autenticada");
// Verificar que el ID del evento sea válido
require(_eventId < eventTicketCount, "ID de evento invalido");
// Verificar que el evento tenga asientos disponibles para la selección
require(eventTickets[_eventId].availableSeats > 0, "No hay asientos disponibles para la seleccion");
// Verificar que el número de filas y columnas coincide con el tamaño del arreglo de asientos
require(_seatRows.length == _seatColumns.length, "Numero de filas y columnas invalido");
// Verificar que los asientos seleccionados estén disponibles
uint seatColumns = eventTickets[_eventId].seats[0].columns;
for (uint i = 0; i < _seatRows.length; i++) {
uint seatIndex = _seatRows[i] * seatColumns + _seatColumns[i];
require(!eventTickets[_eventId].seats[seatIndex].occupied, "Asiento ocupado");
// Marcar el asiento seleccionado como ocupado
eventTickets[_eventId].seats[seatIndex].occupied = true;
}
// Decrementar la cantidad de asientos disponibles
eventTickets[_eventId].availableSeats -= _seatRows.length;
// Emitir un evento para notificar que los asientos han sido elegidos
emit EventSeatsChosen(_eventId, _seatRows, _seatColumns);
}

// Función para reembolsar un ticket de evento
function refundEventTicket(uint256 ticketId) public {
    // Verifica que el ticket no haya sido previamente reembolsado
    require(!refundedTickets[ticketId], "Ticket has already been refunded");

    // Obtiene el ticket de evento correspondiente
    EventTicket storage eventTicket = eventTickets[ticketId];

    // Verifica que el ticket aún no haya expirado
    require(eventTicket.expirationTime > block.timestamp, "Ticket has already expired");

    // Verifica que el usuario que llama a la función sea el propietario del ticket
    require(msg.sender == eventTicket.owner, "Only ticket owner can request a refund");

    // Verifica que el ticket no haya sido revendido
    require(eventTicket.resellable == false || eventTicket.seats[0].occupied == true, "Ticket has been resold and is not refundable");

    // Verifica que el ticket aún esté dentro del período de cancelación
    require(block.timestamp <= eventTicket.purchaseTime + eventTicket.cancellationPeriod, "Ticket is no longer eligible for cancellation");

    // Calcula la cantidad a reembolsar al usuario (el precio del ticket menos una comisión del 10%)
    uint256 refundAmount = eventTicket.price * 9 / 10;

    // Marca el ticket como reembolsado
    refundedTickets[ticketId] = true;

    // Transfiere el monto de reembolso al propietario del ticket
    payable(eventTicket.owner).transfer(refundAmount);

    emit TicketRefunded(ticketId, eventTicket.owner);
}

// Función para Validar un ticket de evento
function validateTicket(string memory _ticketId, string memory _eventId) public payable returns (bool) {
  // Verifica que el ID del ticket y el ID del evento existan
  require(bytes(_ticketId).length > 0, "Ticket ID is required");
  require(bytes(_eventId).length > 0, "Event ID is required");

  // Recorre todos los tickets de evento
  for (uint256 i = 0; i < eventTicketCount; i++) {
    // Verifica si el ID del ticket y el ID del evento coinciden con algún ticket de evento
if (eventTickets[i].qrCode == bytes32(keccak256(abi.encodePacked(_ticketId))) && eventTickets[i].eventId == uint256(keccak256(abi.encodePacked(_eventId)))) {
      // Verifica que el ticket no haya sido utilizado anteriormente
      require(!eventTickets[i].refunded, "Ticket has already been used");
      // Verifica que el ticket no haya expirado
      require(block.timestamp <= eventTickets[i].expirationTime, "Ticket has expired");
      // Verifica que el ticket tenga un nombre
      require(bytes(eventTickets[i].name).length > 0, "Ticket name is required");
      // Verifica que el ticket tenga un precio mayor a cero
      require(eventTickets[i].price > 0, "Ticket price must be greater than zero");
      // Verifica que el ticket tenga un propietario
      require(eventTickets[i].owner != address(0), "Ticket owner is required");
      // Verifica que el ticket tenga un tiempo de expiración
      require(eventTickets[i].expirationTime > 0, "Ticket expiration time is required");
      // Verifica que el ticket tenga una puja permitida
      require(eventTickets[i].auctionAllowed == true || eventTickets[i].auctionAllowed == false, "Ticket auction status is required");
      // Verifica que el ticket tenga una reventa permitida
      require(eventTickets[i].resellable == true || eventTickets[i].resellable == false, "Ticket resell status is required");
      // Verifica que el ticket tenga un precio mínimo permitido para reventa
      require(eventTickets[i].minPrice >= 0, "Ticket minimum resell price must be non-negative");
      // Verifica que el ticket tenga un precio máximo permitido para reventa
      require(eventTickets[i].maxPrice >= eventTickets[i].minPrice, "Ticket maximum resell price must be greater than or equal to minimum resell price");
      // Verifica que el ticket tenga un tiempo de compra
      require(eventTickets[i].purchaseTime > 0, "Ticket purchase time is required");
      // Verifica que el ticket tenga un período de cancelación
      require(eventTickets[i].cancellationPeriod >= 0, "Ticket cancellation period must be non-negative");
      // Verifica que el ticket tenga un certificado de autenticidad
      require(eventTickets[i].authenticityCertificate != address(0), "Ticket authenticity certificate is required");
      // Marca el ticket como utilizado
      eventTickets[i].refunded = true;
      // Emite un evento para notificar que el ticket ha sido validado
      emit TicketValidated(_ticketId, _eventId);
      // Devuelve true para indicar que el ticket es válido
      return true;
}
}
// Devuelve false para indicar que el ticket no es válido
return false;
}

uint256 constant TICKET_PURCHASE_POINTS = 10;

// Función para agregar puntos después de la compra de un boleto
    function addPointsAfterTicketPurchase(address user) internal {
        userRewards[user].points += TICKET_PURCHASE_POINTS;
        emit UserRewardUpdated(user, userRewards[user].points);
    }

uint256 constant EVENT_ATTENDANCE_POINTS = 5;

// Función para agregar puntos después de la asistencia a un evento
function addPointsAfterEventAttendance(address user, uint256 eventId) public {
    // Asegurarse de que el evento exista
    require(eventId < totalEvents, "El evento no existe");

    // Asegurarse de que el evento ya haya ocurrido
    require(events[eventId].startTime < block.timestamp, "El evento aun no ha ocurrido");

    // Asegurarse de que el usuario no haya recibido puntos por este evento antes
    require(eventId != userRewards[user].lastEventAttended, "El usuario ya recibio puntos por este evento");

    // Asegurarse de que el usuario tenga un boleto válido para el evento
    bool hasValidTicket = false;
    for (uint256 i = 0; i < userOwnedTickets[user].length; i++) {
        uint256 ticketId = userOwnedTickets[user][i];
        if (eventTickets[ticketId].eventId == eventId) {
            hasValidTicket = true;
            break;
        }
    }
    require(hasValidTicket, "El usuario no tiene un boleto valido para el evento");

    // Agregar puntos al saldo de puntos del usuario
    userRewards[user].points += EVENT_ATTENDANCE_POINTS;
    userRewards[user].lastEventAttended = eventId;

    emit UserTicketsUpdated(user, userOwnedTickets[user]);
}

uint256 public totalEvents; 

// Función para obtener el resumen de eventos
function getEventSummary() public view returns (uint256 _totalEvents, uint256 totalEventTickets, uint256 totalEventTicketsSold) {
    _totalEvents = totalEvents;
    totalEventTickets = eventTickets.length;

    for (uint256 i = 0; i < totalEvents; i++) {
        totalEventTicketsSold += events[i].soldTickets;
    }
}

// Función para crear un Servicio
uint256 serviceCount = 0;

// Función para crear un servicio de evento
function createService(string memory name, string memory category, string memory location, string memory description, uint256[] memory dates, uint256[] memory availableHours, uint256 ticketCount, uint256 availableTickets, string memory ipfsPhotoHash, string memory ipfsVideoHash, string memory streamingPlatform, uint256 startTime, uint256 endTime, string memory avatarId, string memory currency, string memory hardwareRequirements, address[] memory guestList, string memory accessMode, bool isOnline, bool isPhysical, bool isMetaverso, string memory vrarData) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "User is not authenticated");
    // Verifica que el usuario sea el propietario del servicio
    require(ownerOfService(serviceCount) == msg.sender, "User is not the owner of the service");

    // Crea un nuevo servicio
    EventServiceData memory eventServiceData = EventServiceData({
        name: name,
        category: category,
        location: location,
        description: description,
        dates: dates,
        availableHours: availableHours,
        ticketCount: ticketCount,
        availableTickets: availableTickets,
        owner: msg.sender,
        pendingVerification: true,
        ticketIds: new uint256[](0),
        canBid: false,
        guestList: guestList,
        ipfsPhotoHash: ipfsPhotoHash,
        ipfsVideoHash: ipfsVideoHash,
        streamingPlatform: streamingPlatform,
        startTime: startTime,
        endTime: endTime,
        rating: 0,
        review: "",
        virtualLocation: "",
        virtualLongitude: 0,
        virtualLatitude: 0,
        avatarId: avatarId,
        currency: currency,
        hardwareRequirements: hardwareRequirements,
        accessMode: accessMode,
        isOnline: isOnline,
        isPhysical: isPhysical,
        isMetaverso: isMetaverso,
        VRARData: vrarData
    });
    services[serviceCount] = eventServiceData;
    // Emitir el evento EventServiceDataAdded
    emit EventServiceDataAdded(serviceCount, msg.sender);
    serviceCount++;
}

function ownerOfService(uint256 serviceId) public view returns (address) {
    return services[serviceId].owner;
}

uint256 public itineraryCount;

function addServiceToItinerary(uint256 _serviceId, EventServiceData memory _eventServiceData) public {
    ServiceItinerary memory newService;
    newService.serviceId = _serviceId;
    newService.serviceName = _eventServiceData.name;
    newService.serviceLocation = _eventServiceData.location;
    newService.startTime = _eventServiceData.startTime;
    newService.endTime = _eventServiceData.endTime;
    serviceItinerary[_serviceId] = newService;

    emit ServiceItineraryAdded(_serviceId, itineraryCount);
    itineraryCount++;
}

// Función para dejar una reseña y calificación de un servicio
function leaveServiceReview(uint256 serviceId, uint256 rating, string memory review) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "El usuario no esta autenticado");
    // Verifica que el servicio exista
    require(services[serviceId].ticketCount != 0, "Servicio no encontrado");
    // Verifica que la calificación sea válida (entre 1 y 5)
    require(rating >= 1 && rating <= 5, "Calificacion invalida");
    // Asigna la calificación y la reseña al servicio
    serviceRatings[serviceId] = rating;
    serviceReviews[serviceId] = review;

     emit ServiceRated(serviceId, msg.sender, rating);

    emit ServiceReviewed(serviceId, msg.sender, review);
}

// Función para agregar servicios de evento en línea por streaming
function addOnlineService(uint256 _serviceId, string memory _streamingPlatform, uint256 _startTime, uint256 _endTime) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "El usuario no esta autenticado");
    // Verifica que el ID del servicio sea válido
    require(_serviceId < serviceCount, "ID de servicio invalido");
    // Verifica que el remitente sea el dueño del servicio
    require(services[_serviceId].owner == msg.sender, "No tienes permiso para agregar un servicio en linea para este servicio");
    // Verifica que la plataforma de streaming sea válida
    require(validStreamingPlatform(_streamingPlatform), "Plataforma de streaming invalida");
    // Verifica que la hora de inicio y finalización sean válidas
    require(_startTime < _endTime, "Hora de inicio y finalizacion invalidas");
    // Agrega la información de streaming al servicio correspondiente
    services[_serviceId].streamingPlatform = _streamingPlatform;
    services[_serviceId].startTime = _startTime;
    services[_serviceId].endTime = _endTime;
}

// Función para verificar si la plataforma de streaming es válida
function validStreamingPlatform(string memory platform) internal pure returns (bool) {
bytes32 platformHash = keccak256(bytes(platform));
bytes32 twitchHash = keccak256(bytes("Twitch"));
bytes32 youtubeHash = keccak256(bytes("YouTube"));
bytes32 facebookHash = keccak256(bytes("Facebook"));
return platformHash == twitchHash ||
platformHash == youtubeHash ||
platformHash == facebookHash;
}

// Función para actualizar un servicio de evento
function updateService(uint256 _serviceId, string memory _name, string memory _category, string memory _location, string memory _description, uint256[] memory _dates, uint256[] memory _availableHours, uint256 _ticketCount, uint256 _availableTickets, string memory _ipfsPhotoHash, string memory _ipfsVideoHash) public {
    // Verificar que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "El usuario no esta autenticado");
    // Verificar que el ID del servicio sea válido
    require(_serviceId < serviceCount, "ID de servicio invalido");
    // Verificar que el remitente sea el dueño del servicio
    require(services[_serviceId].owner == msg.sender, "No tienes permiso para actualizar este servicio");
    // Actualizar los datos del servicio
    services[_serviceId].name = _name;
    services[_serviceId].category = _category;
    services[_serviceId].location = _location;
    services[_serviceId].description = _description;
    services[_serviceId].dates = _dates;
    services[_serviceId].availableHours = _availableHours;
    services[_serviceId].ticketCount = _ticketCount;
    services[_serviceId].availableTickets = _availableTickets;
    services[_serviceId].ipfsPhotoHash = _ipfsPhotoHash;
    services[_serviceId].ipfsVideoHash = _ipfsVideoHash;
}

uint256 serviceTicketCount = 0;

function createServiceTicket(string memory name, string memory tipo_reserva, uint256 price, uint minPrice, uint maxPrice, uint256 expirationTime, bool auctionAllowed, bool resellable, uint256 cancellationPeriod, address payable authenticityCertificate, bytes memory qrCode, bytes memory certificate, uint256 sellLimit) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "User is not authenticated");

    POAPServiceTicket memory poapServiceTicket = POAPServiceTicket({
        name: "",
        symbol: "",
        supply: 0,
        serviceId: serviceCount,
        imageHash: "",
        description: "",
        owner: msg.sender,
        assigned: false
    });

    // Crea un nuevo ticket para el servicio
    ServiceTicket memory serviceTicket = ServiceTicket({
        name: name,
        tipo_reserva: tipo_reserva,
        price: price,
        owner: msg.sender,
        expirationTime: expirationTime,
        auctionAllowed: auctionAllowed,
        resellable: resellable,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sellCount: 0,
        sellLimit: sellLimit,
        refunded: false,
        purchaseTime: block.timestamp,
        cancellationPeriod: cancellationPeriod,
        authenticityCertificate: authenticityCertificate,
        qrCode: bytes32(qrCode),
        certificate: bytes32(certificate),
        serviceId: serviceTicketCount,
        isVirtual: false,
        poap: poapServiceTicket,
        seller: address(0)
    });

    // Almacene el serviceTicket en el mapping utilizando el serviceId como clave
    serviceTickets[serviceTicket.serviceId] = serviceTicket;

    // Emitir el evento ServiceTicketCreated
    emit ServiceTicketCreated(serviceTicketCount, msg.sender);
    emit POAPServiceTicketAdded(serviceTicket.serviceId, serviceTicketCount, serviceTicket.name);

    // Incrementar el contador de serviceTicket
    serviceTicketCount++;
}

function confirmServiceAttendance(uint256 serviceId) public {
    // Obtiene el ticket correspondiente al ID del servicio
    ServiceTicket memory serviceTicket = serviceTickets[serviceId];
    // Verifica que el servicio esté disponible
    require(!serviceTicket.refunded, "El servicio ha sido reembolsado");
    // Verifica que la asistencia se esté confirmando antes de la fecha de vencimiento
    require(block.timestamp <= serviceTicket.expirationTime, "El tiempo para confirmar la asistencia ha vencido");
    // Asigna el POAP correspondiente
    POAPServiceTicket memory poapServiceTicket = serviceTicket.poap;
    poapServiceTicket.assigned = true;
    // Actualiza la información del ticket de servicio
    serviceTicket.refunded = false;
    serviceTickets[serviceId] = serviceTicket;
}

// Función para actualizar un Ticket de Servicio
function updateServiceTicket(uint256 _ticketId, string memory _name, string memory _tipo_reserva, uint256 _price, uint _minPrice, uint _maxPrice, uint256 _expirationTime, bool _auctionAllowed, bool _resellable, uint256 _cancellationPeriod, address _authenticityCertificate, bytes memory _qrCode, bytes memory _certificate) public {
    // Verifica que el usuario esté autenticado
    require(authenticatedAccounts[msg.sender], "El usuario no esta autenticado");
    // Verifica que el ID del ticket sea válido
    require(_ticketId < serviceTicketCount, "ID de ticket invalido");
    // Verifica que el remitente sea el propietario del ticket
    require(serviceTickets[_ticketId].owner == msg.sender, "No tienes permiso para actualizar este ticket");
    // Verifica que el período de cancelación sea válido
    require(_cancellationPeriod >= 0, "Periodo de cancelacion invalido");
    // Actualiza los datos del ticket de servicio
    serviceTickets[_ticketId].name = _name;
    serviceTickets[_ticketId].tipo_reserva = _tipo_reserva;
    serviceTickets[_ticketId].price = _price;
    serviceTickets[_ticketId].minPrice = _minPrice;
    serviceTickets[_ticketId].maxPrice = _maxPrice;
    serviceTickets[_ticketId].expirationTime = _expirationTime;
    serviceTickets[_ticketId].auctionAllowed = _auctionAllowed;
    serviceTickets[_ticketId].resellable = _resellable;
    serviceTickets[_ticketId].cancellationPeriod = _cancellationPeriod;
    serviceTickets[_ticketId].authenticityCertificate = _authenticityCertificate;
    serviceTickets[_ticketId].qrCode = bytes32(_qrCode);
    serviceTickets[_ticketId].certificate = bytes32(_certificate);
}

function assignServiceTicketToService(uint serviceId, uint ticketId) public {
    // Obtiene el servicio correspondiente a la ID proporcionada
    EventServiceData memory serviceData = services[serviceId];
    // Obtiene el ticket correspondiente a la ID proporcionada
    ServiceTicket memory serviceTicket = serviceTickets[ticketId];
    // Verifica que el usuario sea el propietario del servicio
    require(serviceData.owner == msg.sender, "User is not the owner of the service");
    // Verifica que el ticket pertenezca al usuario
    require(serviceTicket.owner == msg.sender, "User does not own the service ticket");
    // Asigna el ticket al servicio
    serviceTicketIds[serviceId].push(ticketId);
    serviceData.ticketCount++;
    serviceData.availableTickets--;

    emit ServiceTicketsSigned(serviceId, serviceTicketIds[serviceId]);
}

// Función para iniciar una subasta para un ticket de servicio
function startServiceTicketAuction(uint ticketId) public {
// Obtiene el ticket correspondiente a la ID proporcionada
ServiceTicket memory serviceTicket = serviceTickets[ticketId];
// Verifica que el ticket permita subastas
require(serviceTicket.auctionAllowed, "Auctions are not allowed for this service ticket");
// Verifica que la subasta no haya comenzado
require(!auctionStarted[ticketId], "Auction has already started for this service ticket");
// Inicializa la subasta para el ticket
auctionStarted[ticketId] = true;
Auction memory auction = Auction({
startingPrice: serviceTicket.price,
currentPrice: serviceTicket.price,
highestBidder: address(0),
highestBid: 0,
endingTime: block.timestamp + 7 days
});
auctions[ticketId] = auction;

// Emitir el evento ServiceAuctionCreated con los detalles relevantes
    emit ServiceAuctionCreated(ticketId, serviceTicket.owner, auction.startingPrice, auctions[ticketId].endingTime);
}

// Función para hacer una puja en una subasta de un ticket de servicio
function bidOnServiceTicketAuction(uint ticketId, uint256 value) public payable {
// Obtiene la subasta correspondiente a la ID de ticket proporcionada
Auction memory auction = auctions[ticketId];
// Verifica que la subasta haya comenzado
require(auctionStarted[ticketId], "Auction has not started for this service ticket");
// Verifica que la subasta no haya terminado
require(block.timestamp <= auction.endingTime, "Auction has ended");
// Verifica que la puja sea mayor que la puja actual
require(value > auction.currentPrice, "Bid must be higher than current price");
// Actualiza la puja actual y el postor con la puja proporcionada
auction.highestBid = value;
auction.highestBidder = msg.sender;
auction.currentPrice = value;
}

// Función para finalizar una subasta de un ticket de servicio
function endServiceTicketAuction(uint ticketId) public view {
// Obtiene la subasta correspondiente a la ID de ticket proporcionada
Auction memory auction = auctions[ticketId];
// Verifica que la subasta haya comenzado
require(auctionStarted[ticketId], "Auction has not started for this service ticket");
// Verifica que la subasta haya terminado
require(block.timestamp > auction.endingTime, "Auction has not ended");
// Transfiere el ticket al postor ganador de la subasta
ServiceTicket memory serviceTicket = serviceTickets[ticketId];
serviceTicket.owner = auction.highestBidder;
}

function buyServiceTicketWithCryptocurrency(uint256 _ticketId, string memory _couponCode, address payable sellerAddress) public payable {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < serviceTickets.length, "ID de ticket invalido");
    // Verificar que el ticket no tenga un propietario
    require(serviceTickets[_ticketId].owner == address(0), "El ticket ya tiene propietario");
    // Verificar que el ticket no haya expirado
    require(serviceTickets[_ticketId].expirationTime == 0 || serviceTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");

    uint256 ticketPrice = serviceTickets[_ticketId].price;
    uint256 newTicketPrice = ticketPrice;

    // Si se proporciona un código de cupón, aplicar el descuento
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "Coupon code does not exist");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "Coupon is not active");
        require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

        uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;
        newTicketPrice = ticketPrice - discountAmount;
    }

    // Verificar que el monto recibido sea igual al precio del ticket (con descuento, si corresponde)
    require(msg.value == newTicketPrice, "Monto incorrecto");

    // Transferir el monto de criptomonedas al vendedor
    sellerAddress.transfer(msg.value);
    // Transferir el ticket al comprador especificado
    safeTransferFrom(address(0), msg.sender, _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTickets[_ticketId].owner = msg.sender;
    // Incrementar la cantidad de tickets disponibles para el servicio
    services[serviceTickets[_ticketId].serviceId].availableTickets++;

    // Si se utilizó un cupón, desactivarlo después de su uso
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        coupons[couponId].isActive = false;
        emit CouponRedeemed(couponId, msg.sender);
    }
}

function sellServiceTicketWithCryptocurrency(uint256 _ticketId, uint256 _priceInWei, address payable commissionWallet) public payable {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < serviceTickets.length, "ID de ticket invalido");
    // Verificar que el ticket tenga un propietario
    require(serviceTickets[_ticketId].owner == msg.sender, "El ticket no tiene propietario");
    // Verificar que el ticket no haya expirado
    require(serviceTickets[_ticketId].expirationTime == 0 || serviceTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
    // Verificar que el monto recibido sea igual al precio del ticket
    require(msg.value == _priceInWei, "Monto incorrecto");
    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Retener la comisión
    commissionWallet.transfer(commission);
    
    // Transferir el ticket al comprador especificado
    safeTransferFrom(msg.sender, address(this), _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTickets[_ticketId].owner = address(this);
    
    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de criptomonedas al vendedor (menos la comisión)
    vendorAddress.transfer(msg.value - commission);

    // Decrementar la cantidad de tickets disponibles para el servicio
    services[serviceTickets[_ticketId].serviceId].availableTickets--;
}

function buyServiceTicketWithStripe(uint256 _ticketId, string memory _couponCode, uint256 _priceInWei, address payable vendorAddress) public payable {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < serviceTickets.length, "ID de ticket invalido");
    // Verificar que el ticket no tenga un propietario
    require(serviceTickets[_ticketId].owner == address(0), "El ticket ya tiene un propietario");
    // Verificar que el ticket no haya expirado
    require(serviceTickets[_ticketId].expirationTime == 0 || serviceTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");

    uint256 ticketPrice = serviceTickets[_ticketId].price;
    uint256 newTicketPrice = ticketPrice;

    // Si se proporciona un código de cupón, aplicar el descuento
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "Coupon code does not exist");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "Coupon is not active");
        require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

        uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;
        newTicketPrice = ticketPrice - discountAmount;
    }

    // Verificar que el monto recibido sea igual al precio del ticket (con descuento, si corresponde)
    require(msg.value == _priceInWei, "Monto incorrecto");

    // Transferir el ticket al comprador especificado
    safeTransferFrom(address(0), msg.sender, _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTickets[_ticketId].owner = msg.sender;

    // Transferir el monto de criptomonedas al vendedor
    vendorAddress.transfer(msg.value);

    // Decrementar la cantidad de tickets disponibles para el servicio
    services[serviceTickets[_ticketId].serviceId].availableTickets--;
}

function sellServiceTicketWithStripe(uint256 _ticketId, uint256 _priceInWei, address payable commissionWallet) public {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < serviceTickets.length, "ID de ticket invalido");
    // Verificar que el ticket tenga un propietario
    require(serviceTickets[_ticketId].owner == msg.sender, "El ticket no tiene propietario");
    // Verificar que el ticket no haya expirado
    require(serviceTickets[_ticketId].expirationTime == 0 || serviceTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Retener la comisión
    commissionWallet.transfer(commission);

    // Transferir el ticket al comprador especificado
    safeTransferFrom(msg.sender, address(this), _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTickets[_ticketId].owner = address(this);

    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de criptomonedas al vendedor (menos la comisión)
    vendorAddress.transfer(_priceInWei - commission);

    // Decrementar la cantidad de asientos disponibles para el servicio
    services[serviceTickets[_ticketId].serviceId].availableTickets--;
}

function buyServiceTicketWithPaypal(uint256 _ticketId, string memory _couponCode, uint256 _priceInWei, address payable commissionWallet) public payable {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < serviceTickets.length, "ID de ticket invalido");
    // Verificar que el ticket no tenga un propietario
    require(serviceTickets[_ticketId].owner == address(0), "El ticket ya tiene un propietario");
    // Verificar que el ticket no haya expirado
    require(serviceTickets[_ticketId].expirationTime == 0 || serviceTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");

    uint256 ticketPrice = serviceTickets[_ticketId].price;
    uint256 newTicketPrice = ticketPrice;

    // Si se proporciona un código de cupón, aplicar el descuento
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "Coupon code does not exist");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "Coupon is not active");
        require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

        uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;
        newTicketPrice = ticketPrice - discountAmount;
    }

    // Verificar que el monto recibido sea igual al precio del ticket (con descuento, si corresponde)
    require(msg.value == _priceInWei, "Monto incorrecto");

    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Retener la comisión
    commissionWallet.transfer(commission);

    // Transferir el ticket al comprador especificado
    safeTransferFrom(address(0), msg.sender, _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTickets[_ticketId].owner = msg.sender;

    // Decrementar la cantidad de tickets disponibles para el servicio
    services[serviceTickets[_ticketId].serviceId].availableTickets--;
}

function sellServiceTicketWithPaypal(uint256 _ticketId, uint256 _priceInWei, address payable commissionWallet) public {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < serviceTickets.length, "ID de ticket invalido");
    // Verificar que el ticket tenga un propietario
    require(serviceTickets[_ticketId].owner == msg.sender, "El ticket no tiene propietario");
    // Verificar que el ticket no haya expirado
    require(serviceTickets[_ticketId].expirationTime == 0 || serviceTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
    // Calcular la comisión de la transacción
    uint256 commission = SafeMath.div(SafeMath.mul(_priceInWei, 25), 1000);
    // Retener la comisión
    commissionWallet.transfer(commission);

    // Transferir el ticket al comprador especificado
    safeTransferFrom(msg.sender, address(this), _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTickets[_ticketId].owner = address(this);

    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de criptomonedas al vendedor (menos la comisión)
    vendorAddress.transfer(_priceInWei - commission);

    // Decrementar la cantidad de asientos disponibles para el servicio
    services[serviceTickets[_ticketId].serviceId].availableTickets--;
}

function buyLastMinuteServiceTicketWithCryptocurrency(uint256 _serviceId, uint256 _ticketId, string memory _couponCode, address payable sellerAddress, uint256 timeLeft) public payable {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "La cuenta no esta autenticada");
    // Verificar que el ID del ticket sea válido
    require(_ticketId < serviceTickets.length, "ID de ticket invalido");
    // Verificar que el ticket no tenga un propietario
    require(serviceTickets[_ticketId].owner == address(0), "El ticket ya tiene propietario");
    // Verificar que el ticket no haya expirado
    require(serviceTickets[_ticketId].expirationTime == 0 || serviceTickets[_ticketId].expirationTime > block.timestamp, "El ticket ha expirado");
    // Verificar que el ticket sea de último minuto
    require(serviceTickets[_ticketId].expirationTime - block.timestamp <= timeLeft, "El ticket no es de ultimo minuto");

    uint256 ticketPrice = serviceTickets[_ticketId].price;
    uint256 newTicketPrice = ticketPrice;

    // Si se proporciona un código de cupón, aplicar el descuento
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        require(couponId != 0, "Coupon code does not exist");

        Coupon memory coupon = coupons[couponId];
        require(coupon.isActive, "Coupon is not active");
        require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

        uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;
        newTicketPrice = ticketPrice - discountAmount;
    }

    // Verificar que el monto recibido sea igual al precio del ticket (con descuento, si corresponde)
    require(msg.value == newTicketPrice, "Monto incorrecto");

    // Transferir el monto de criptomonedas al vendedor
    sellerAddress.transfer(msg.value);
    // Transferir el ticket al comprador especificado
    safeTransferFrom(address(0), msg.sender, _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTickets[_ticketId].owner = msg.sender;
    // Incrementar la cantidad de tickets disponibles para el servicio
    services[serviceTickets[_ticketId].serviceId].availableTickets++;

    // Si se utilizó un cupón, desactivarlo después de su uso
    if (bytes(_couponCode).length > 0) {
        uint256 couponId = couponIdsByCode[_couponCode];
        coupons[couponId].isActive = false;
        emit CouponRedeemed(couponId, msg.sender);
    }

    // Emitir un evento para la compra de un ticket de servicio de último minuto
    emit LastMinuteServiceTicketPurchased(_serviceId, _ticketId, msg.sender, newTicketPrice);
}

function sellLastMinuteServiceTicket(uint256 _serviceId, uint256 _ticketId, address payable commissionWallet) public payable {
    ServiceTicket storage serviceTicket = serviceTickets[_serviceId];

    require(serviceTicket.owner == msg.sender, "Solo el propietario del ticket puede venderlo");
    require(block.timestamp >= serviceTicket.expirationTime - 1 hours, "La venta de ultimo minuto solo es valida dentro de la ultima hora antes de la expiracion");

    // El cálculo de la comisión ya está usando partes por mil en lugar de porcentaje
    uint256 fee = (serviceTicket.price * transactionFee) / 1000;
    uint256 netPrice = serviceTicket.price - fee;

    // Verificar que el monto recibido sea igual al precio del ticket
    require(msg.value == serviceTicket.price, "Monto incorrecto");

    // Retener la comisión
    commissionWallet.transfer(fee);

    // Transferir el ticket al comprador especificado
    safeTransferFrom(msg.sender, address(this), _ticketId);
    // Actualizar la dirección del propietario del ticket
    serviceTicket.owner = address(this);
    // Asignar el valor del vendedor al campo "seller"
    serviceTicket.seller = msg.sender;

    // Crear una dirección pagable a partir de la dirección original
    address payable vendorAddress = payable(msg.sender);
    // Transferir el monto de criptomonedas al vendedor (menos la comisión)
    vendorAddress.transfer(netPrice);

    emit LastMinuteServiceTicketSold(_serviceId, _ticketId, msg.sender, serviceTicket.price);
}

// Función para reembolsar un ticket de servicio
function refundServiceTicket(uint256 ticketId) public {
    // Verifica que el ticket no haya sido previamente reembolsado
    require(!refundedServiceTickets[ticketId], "Ticket has already been refunded");

    // Obtiene el ticket de servicio correspondiente
    ServiceTicket storage serviceTicket = serviceTickets[ticketId];

    // Verifica que el ticket aún no haya expirado
    require(serviceTicket.expirationTime > block.timestamp, "Ticket has already expired");

    // Verifica que el usuario que llama a la función sea el propietario del ticket
    require(msg.sender == serviceTicket.owner, "Only ticket owner can request a refund");

    // Verifica que el ticket aún esté dentro del período de cancelación
require(block.timestamp <= serviceTicket.purchaseTime + serviceTicket.cancellationPeriod, "Ticket is no longer eligible for cancellation");

    // Calcula la cantidad a reembolsar al usuario (el precio del ticket menos una comisión del 10%)
    uint256 refundAmount = serviceTicket.price * 9 / 10;

    // Marca el ticket como reembolsado
    refundedServiceTickets[ticketId] = true;

    // Transfiere el monto de reembolso al propietario del ticket
    payable(serviceTicket.owner).transfer(refundAmount);

    emit ServiceTicketRefunded(ticketId, serviceTicket.owner);
}

// Función para Validar un ticket de servicio
function validateServiceTicket(string memory _ticketId, string memory _serviceId) public payable returns (bool) {
  // Verifica que el ID del ticket y el ID del servicio existan
  require(bytes(_ticketId).length > 0, "Ticket ID is required");
  require(bytes(_serviceId).length > 0, "Service ID is required");

  // Recorre todos los tickets de servicio
  for (uint256 i = 0; i < serviceTicketCount; i++) {
    // Verifica si el ID del ticket y el ID del servicio coinciden con algún ticket de servicio
    if (serviceTickets[i].qrCode == bytes32(keccak256(abi.encodePacked(_ticketId))) && serviceTickets[i].serviceId == uint256(keccak256(abi.encodePacked(_serviceId)))) {
      // Verifica que el ticket no haya sido utilizado anteriormente
      require(!serviceTickets[i].refunded, "Ticket has already been used");
      // Verifica que el ticket no haya expirado
      require(block.timestamp <= serviceTickets[i].expirationTime, "Ticket has expired");
      // Verifica que el ticket tenga un nombre
      require(bytes(serviceTickets[i].name).length > 0, "Ticket name is required");
      // Verifica que el ticket tenga un precio mayor a cero
      require(serviceTickets[i].price > 0, "Ticket price must be greater than zero");
      // Verifica que el ticket tenga un propietario
      require(serviceTickets[i].owner != address(0), "Ticket owner is required");
      // Verifica que el ticket tenga un tiempo de expiración
      require(serviceTickets[i].expirationTime > 0, "Ticket expiration time is required");
      // Verifica que el ticket tenga una puja permitida
      require(serviceTickets[i].auctionAllowed == true || serviceTickets[i].auctionAllowed == false, "Ticket auction status is required");
      // Verifica que el ticket tenga una reventa permitida
      require(serviceTickets[i].resellable == true || serviceTickets[i].resellable == false, "Ticket resell status is required");
      // Verifica que el ticket tenga un precio mínimo permitido para reventa
      require(serviceTickets[i].minPrice >= 0, "Ticket minimum resell price must be non-negative");
      // Verifica que el ticket tenga un precio máximo permitido para reventa
      require(serviceTickets[i].maxPrice >= serviceTickets[i].minPrice, "Ticket maximum resell price must be greater than or equal to minimum resell price");
      // Verifica que el ticket tenga un tiempo de compra
      require(serviceTickets[i].purchaseTime > 0, "Ticket purchase time is required");
      // Verifica que el ticket tenga un período de cancelación
      require(serviceTickets[i].cancellationPeriod >= 0, "Ticket cancellation period must be non-negative");
      // Verifica que el ticket tenga un certificado de autenticidad
      require(serviceTickets[i].authenticityCertificate != address(0), "Ticket authenticity certificate is required");
      // Marca el ticket como utilizado
      serviceTickets[i].refunded = true;
      // Emite un evento para notificar que el ticket ha sido validado
      emit ServiceTicketValidated(_ticketId, _serviceId);
      // Devuelve true para indicar que el ticket es válido
      return true;
     }
}

// Devuelve false para indicar que el ticket no es válido
return false;
}

uint256 constant TICKET_SERVICE_POINTS = 10;

function addPointsAfterTicketService(address user) internal {
    userRewards[user].points += TICKET_SERVICE_POINTS;
}

uint256 constant SERVICE_ATTENDANCE_POINTS = 5;

function addPointsAfterServiceAttendance(address user, uint256 serviceId) public {
    // Asegurarse de que el servicio exista
    require(serviceId < totalServices, "El servicio no existe");

    // Asegurarse de que el servicio ya haya ocurrido
    require(services[serviceId].startTime < block.timestamp, "El servicio aun no ha ocurrido");
    // Asegurarse de que el usuario no haya recibido puntos por este servicio antes
    require(serviceId != userRewards[user].lastServiceAttended, "El usuario ya recibio puntos por este servicio");

    // Asegurarse de que el usuario tenga un boleto válido para el servicio
    bool hasValidTicket = false;
    for (uint256 i = 0; i < userOwnedServiceTickets[user].length; i++) {
        uint256 ticketId = userOwnedServiceTickets[user][i];
        if (serviceTickets[ticketId].serviceId == serviceId) {
            hasValidTicket = true;
            break;
        }
    }
    require(hasValidTicket, "El usuario no tiene un boleto valido para el servicio");

    // Agregar puntos al saldo de puntos del usuario
    userRewards[user].points += SERVICE_ATTENDANCE_POINTS;
    userRewards[user].lastServiceAttended = serviceId;

    emit UserServiceTicketsUpdated(user, userOwnedServiceTickets[user]);
}

uint256 public totalServices;

// Función para obtener el resumen de servicios
function getServiceSummary() public view returns (uint256 _totalServices, uint256 totalServiceTickets, uint256 totalServiceTicketsSold) {
    _totalServices = totalServices;
    totalServiceTickets = serviceTickets.length;

    for (uint256 i = 0; i < totalServices; i++) {
        uint256 soldTickets = services[i].ticketCount - services[i].availableTickets;
        totalServiceTicketsSold += soldTickets;
    }
}

// Agrega un nuevo escenario
function addScene(uint _id, string memory _name, string[] memory _objects, string[] memory _characters) public {
    Scene memory newScene;
    newScene.id = _id;
    newScene.name = _name;
    newScene.objects = _objects;
    newScene.characters = _characters;
    scenes[_id] = newScene;

    emit SceneAdded(_id, _name, "", 0);
}

    // Agrega un nuevo personaje
    function addCharacter(uint _id, string memory _name) public {
    Character memory newCharacter;
    newCharacter.id = _id;
    newCharacter.name = _name;
    characters[_id] = newCharacter;

    emit CharacterAdded(_id, _name, newCharacter.description, newCharacter.level);
    }

    // Agrega un nuevo objeto
function addObject(uint _id, string memory _name, string memory _appearance, string[] memory _actions, uint256 _value) public {
    Object memory newObject;
    newObject.id = _id;
    newObject.name = _name;
    newObject.appearance = _appearance;
    newObject.actions = _actions;
    newObject.value = _value;
    objects[_id] = newObject;

    emit ObjectAdded(_id, _name, _appearance, _value);
}

    // Devuelve la apariencia de un objeto como una cadena
    function getAppearanceString(Appearance appearance) public pure returns (string memory) {
        if (appearance == Appearance.Shiny) {
            return "Shiny";
        } else if (appearance == Appearance.Dull) {
            return "Dull";
        } else if (appearance == Appearance.Rusty) {
            return "Rusty";
        } else {
            return "Unknown";
        }
    }

    // Devuelve la acción de un objeto como una cadena
    function getActionString(Action action) public pure returns (string memory) {
        if (action == Action.Pickup) {
            return "Pickup";
        } else if (action == Action.Drop) {
            return "Drop";
        } else if (action == Action.Use) {
            return "Use";
        } else {
            return "Unknown";
        }
    }

uint256 public sponsorCount = 0;

// Función para agregar un patrocinador
function addSponsor(string memory _name, string memory _website, string memory _description, uint _discountPercentage) public {
    // Verificar que el patrocinador no esté ya registrado
    for (uint i = 0; i < sponsorCount; i++) {
        require(keccak256(abi.encodePacked(sponsors[i].name)) != keccak256(abi.encodePacked(_name)), "Este patrocinador ya esta registrado");
    }
    // Añadir el patrocinador
    sponsors[sponsorCount] = Sponsor({
    id: sponsorCount,
    name: _name,
    website: _website,
    description: _description,
    discountPercentage: _discountPercentage,
    isActive: true,
    balance: 0
});
    // Incrementar el número de patrocinadores registrados
    sponsorCount++;

    emit SponsorAdded(sponsorCount, msg.sender, _name, _website);
}

// Función para obtener la información de un patrocinador específico
function getSponsor(uint id) public view returns (string memory, string memory, string memory, uint) {
    // Verifica que el patrocinador exista
    require(sponsors[id].isActive, "Sponsor does not exist");
    // Obtiene el patrocinador
    Sponsor memory sponsor = sponsors[id];
    // Devuelve el nombre, descripción y URL del patrocinador, así como el ID del patrocinador
    return (sponsor.name, sponsor.description, sponsor.website, id);
}

// Función para obtener la lista de patrocinadores registrados en la plataforma
function getSponsors() public view returns (Sponsor[] memory) {
    // Crea un arreglo de patrocinadores
    Sponsor[] memory sponsorsArray = new Sponsor[](sponsorCount);
    // Recorre el mapeo de patrocinadores y llena el arreglo con los patrocinadores activos
uint j = 0;
for (uint i = 0; i < sponsorCount; i++) {
if (sponsors[i].isActive) {
sponsorsArray[j] = sponsors[i];
j++;
}
}
// Devuelve el arreglo de patrocinadores
return sponsorsArray;
}

// Función para agregar un ticket de evento patrocinado
function addSponsoredEventTicket(uint _eventTicketId, uint _sponsorId) public {
  // Verifica que el ticket de evento exista
  require(eventTickets[_eventTicketId].eventId != 0, "Event ticket does not exist");
  // Verifica que el patrocinador exista y esté activo
  require(sponsors[_sponsorId].isActive, "Sponsor does not exist or is inactive");
  // Añade el ticket de evento patrocinado al mapeo de tickets de eventos patrocinados
  sponsoredEventTickets[_eventTicketId] = SponsoredEventTicket(_eventTicketId, _sponsorId, 0, false);

  emit SponsoredEventTicketAdded(_eventTicketId, _sponsorId);
}

// Función para obtener la lista de tickets de tickets de eventos patrocinados
function getSponsoredEventTickets() public view returns (SponsoredEventTicket[] memory) {
  // Crea un arreglo de tickets de eventos patrocinados
  SponsoredEventTicket[] memory sponsoredEventTicketsArray = new SponsoredEventTicket[](eventTicketCount);
  // Recorre el mapeo de tickets de eventos patrocinados y llena el arreglo con los tickets de eventos patrocinados
  uint j = 0;
  for (uint i = 0; i < eventTicketCount; i++) {
    if (sponsoredEventTickets[i].sponsorId != 0) {
      sponsoredEventTicketsArray[j] = sponsoredEventTickets[i];
      j++;
    }
  }
  // Devuelve el arreglo de tickets de eventos patrocinados
  return sponsoredEventTicketsArray;
}

// Función para obtener el patrocinador de un ticket de evento específico
function getEventTicketSponsor(uint _eventTicketId) public view returns (uint) {
  // Verifica que el ticket de evento exista
  require(sponsoredEventTickets[_eventTicketId].sponsorId != 0, "Event ticket is not sponsored");
  // Devuelve el ID del patrocinador del ticket de evento
  return sponsoredEventTickets[_eventTicketId].sponsorId;
}

// Función para aplicar un descuento a un ticket de evento patrocinado
function applyEventTicketDiscount(uint _eventTicketId) public view returns (uint) {
  // Verifica que el ticket de evento exista
  require(eventTickets[_eventTicketId].eventId != 0, "Event ticket does not exist");
// Verifica que el ticket de evento esté patrocinado
require(sponsoredEventTickets[_eventTicketId].sponsorId != 0, "Event ticket is not sponsored");
// Obtiene el patrocinador del ticket de evento
// Obtiene el ID del patrocinador
uint sponsorId = sponsoredEventTickets[_eventTicketId].sponsorId;
// Obtiene la información del patrocinador
// Verifica que el patrocinador esté activo
require(sponsors[sponsorId].isActive, "Sponsor is inactive");
// Aplica el descuento del patrocinador al precio del ticket de evento
uint discount = (eventTickets[_eventTicketId].price * sponsors[sponsorId].discountPercentage) / 100;
return discount;
}

// Función para agregar un ticket de servicio patrocinado
function addSponsoredServiceTicket(uint _serviceTicketId, uint _sponsorId) public {
// Verifica que el ticket de servicio exista
require(serviceTickets[_serviceTicketId].serviceId != 0, "Service ticket does not exist");
// Verifica que el patrocinador exista y esté activo
require(sponsors[_sponsorId].isActive, "Sponsor does not exist or is inactive");
// Añade el ticket de servicio patrocinado al mapeo de tickets de servicios patrocinados
sponsoredServiceTickets[_serviceTicketId] = SponsoredServiceTicket(_serviceTicketId, _sponsorId, 0, false);

emit SponsoredServiceTicketAdded(_serviceTicketId, _sponsorId);
}

// Función para obtener la lista de tickets de servicios patrocinados
function getSponsoredServiceTickets() public view returns (SponsoredServiceTicket[] memory) {
// Crea un arreglo de tickets de servicios patrocinados
SponsoredServiceTicket[] memory sponsoredServiceTicketsArray = new SponsoredServiceTicket[](serviceTicketCount);
// Recorre el mapeo de tickets de servicios patrocinados y llena el arreglo con los tickets de servicios patrocinados
uint j = 0;
for (uint i = 0; i < serviceTicketCount; i++) {
if (sponsoredServiceTickets[i].sponsorId != 0) {
sponsoredServiceTicketsArray[j] = sponsoredServiceTickets[i];
j++;
}
}
// Devuelve el arreglo de tickets de servicios patrocinados
return sponsoredServiceTicketsArray;
}

// Función para obtener el patrocinador de un ticket de servicio específico
function getServiceTicketSponsor(uint _serviceTicketId) public view returns (uint) {
// Verifica que el ticket de servicio exista
require(sponsoredServiceTickets[_serviceTicketId].sponsorId != 0, "Service ticket is not sponsored");
// Devuelve el ID del patrocinador del ticket de servicio
return sponsoredServiceTickets[_serviceTicketId].sponsorId;
}

// Función para aplicar un descuento a un ticket de servicio patrocinado
function applyServiceTicketDiscount(uint _serviceTicketId) public view returns (uint) {
// Verifica que el ticket de servicio exista
require(serviceTickets[_serviceTicketId].serviceId != 0, "Service ticket does not exist");
// Verifica que el ticket de servicio esté patrocinado
require(sponsoredServiceTickets[_serviceTicketId].sponsorId != 0, "Service ticket is not sponsored");
// Obtiene el patrocinador del ticket de servicio
// Obtiene el ID del patrocinador
uint sponsorId = sponsoredServiceTickets[_serviceTicketId].sponsorId;
// Obtiene la información del patrocinador
// Verifica que el patrocinador esté activo
require(sponsors[sponsorId].isActive, "Sponsor is inactive");
// Aplica el descuento del patrocinador al precio del ticket de servicio
uint discount = (serviceTickets[_serviceTicketId].price * sponsors[sponsorId].discountPercentage) / 100;
return discount;
}

function addMerchandiseSponsor(uint256 _merchandiseId, uint256 _sponsorId) public {
  // Verifica que el merchandise exista y esté activo
  require(merchandiseList[_merchandiseId].isActive, "Merchandise does not exist or is inactive");
  // Verifica que el patrocinador exista y esté activo
  require(sponsors[_sponsorId].isActive, "Sponsor does not exist or is inactive");
  // Añade el patrocinador de merchandise al mapeo de patrocinadores de merchandise
  merchandiseSponsors[_merchandiseId] = MerchandiseSponsor({
    merchandiseId: _merchandiseId,
    sponsorId: _sponsorId
  });

  emit MerchandiseSponsored(_merchandiseId, _sponsorId, merchandiseList[_merchandiseId].price);
}

uint totalMerchandiseCount;

// Función para obtener la lista de patrocinadores de merchandise
function getMerchandiseSponsors() public view returns (MerchandiseSponsor[] memory) {
  // Crea un arreglo de patrocinadores de merchandise
  MerchandiseSponsor[] memory merchandiseSponsorsArray = new MerchandiseSponsor[](totalMerchandiseCount);
  // Recorre el mapeo de patrocinadores de merchandise y llena el arreglo con los patrocinadores de merchandise activos
  uint j = 0;
  for (uint i = 0; i < totalMerchandiseCount; i++) {
    if (merchandiseSponsors[i].sponsorId != 0) {
      merchandiseSponsorsArray[j] = merchandiseSponsors[i];
      j++;
    }
  }
  // Devuelve el arreglo de patrocinadores de merchandise
  return merchandiseSponsorsArray;
}

// Función para obtener el patrocinador de un merchandise específico
function getMerchandiseSponsor(uint _merchandiseId) public view returns (uint) {
  // Verifica que el merchandise exista
  require(merchandiseList[_merchandiseId].eventId != 0, "Merchandise does not exist");
  // Verifica que el merchandise esté patrocinado
  require(merchandiseSponsors[_merchandiseId].sponsorId != 0, "Merchandise is not sponsored");
  // Devuelve el ID del patrocinador del merchandise
  return merchandiseSponsors[_merchandiseId].sponsorId;
}

// Función para aplicar un descuento a un merchandise patrocinado
function applyMerchandiseDiscount(uint256 _merchandiseId, uint256 _sponsorId, uint256 _amount) public {
  // Verifica que el merchandise exista
  require(merchandiseList[_merchandiseId].eventId != 0, "Merchandise does not exist");
  // Verifica que el merchandise esté patrocinado
  require(merchandiseSponsors[_merchandiseId].sponsorId != 0, "El merchandise no esta patrocinado");
  // Verifica que el patrocinador exista
  require(sponsors[_sponsorId].id != 0, "El patrocinador no existe");
  // Verifica que el patrocinador no haya patrocinado este merchandise antes
  require(merchandiseSponsors[_merchandiseId].sponsorId != _sponsorId, "El patrocinador ya ha patrocinado este merchandise antes");
  // Verifica que el patrocinador tenga suficientes fondos para patrocinar el merchandise
  require(sponsors[_sponsorId].balance >= _amount, "El patrocinador no tiene suficientes fondos para patrocinar este merchandise");
  
  // Obtiene el eventId asociado al merchandiseId
  uint256 eventId = merchandiseList[_merchandiseId].eventId;
  
  // Transfiere los fondos del patrocinador al organizador del evento
 organizerBalances[merchandise[eventId][_merchandiseId].organizerId] += _amount;
  // Actualiza el balance del patrocinador
  sponsors[_sponsorId].balance -= _amount;
  // Asigna al patrocinador al merchandise
  merchandiseSponsors[_merchandiseId] = MerchandiseSponsor(_merchandiseId, _sponsorId);
  
  emit MerchandiseSponsored(_merchandiseId, _sponsorId, _amount);
}

// Función para Búsqueda y filtrado de eventos y servicios
function compareStrings(string memory a, string memory b) public pure returns (bool) {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
}

function searchEventsAndServices(SearchFilter memory filter) public view returns (EventData[] memory, EventServiceData[] memory) {
    uint256 i;
    uint256 count = 0;
    uint256[] memory serviceKeys = new uint256[](serviceCount);
    EventData[] memory eventsFiltered = new EventData[](1);
    EventServiceData[] memory servicesFiltered = new EventServiceData[](1);

    // Búsqueda y filtrado de eventos
    for (i = 1; i <= eventCount; i++) {
        if (compareStrings(filter.name, events[i].name) &&
            compareStrings(filter.location, events[i].location) &&
            filter.startDate <= events[i].date &&
            filter.endDate >= events[i].date &&
            filter.minCapacity <= events[i].capacity &&
            filter.maxCapacity >= events[i].capacity &&
            (!filter.isVerified || !events[i].pendingVerification) &&
            (!filter.canBid || events[i].canBid)) {
                eventsFiltered[count] = events[i];
                count++;
        }
    }

    // Búsqueda y filtrado de servicios de eventos
    count = 0;
    for (i = 0; i < serviceCount; i++) {
        serviceKeys[i] = i;
        if (compareStrings(filter.name, services[serviceKeys[i]].name) &&
            compareStrings(filter.location, services[serviceKeys[i]].location) &&
            filter.startDate <= services[serviceKeys[i]].dates[0] &&
            filter.endDate >= services[serviceKeys[i]].dates[services[serviceKeys[i]].dates.length - 1] &&
            filter.minCapacity <= services[serviceKeys[i]].ticketCount &&
            filter.maxCapacity >= services[serviceKeys[i]].ticketCount &&
            (!filter.isVerified || !services[serviceKeys[i]].pendingVerification) &&
            (!filter.canBid || services[serviceKeys[i]].canBid)) {
                servicesFiltered[count] = services[serviceKeys[i]];
               count++;
        }
    }

    // Redimensionar los arreglos para eliminar los espacios vacíos
   EventData[] memory eventsFilteredFinal;
   EventServiceData[] memory servicesFilteredFinal;


    for (i = 0; i < count; i++) {
        eventsFilteredFinal[i] = eventsFiltered[i];
        servicesFilteredFinal[i] = servicesFiltered[i];
    }

    return (eventsFilteredFinal, servicesFilteredFinal);
}

// Método para realizar la reventa de un ticket de evento
function resellEventTicket(uint256 _tokenId, uint _price) public {
  // Verificar que la cuenta del remitente esté autenticada
  require(authenticatedAccounts[msg.sender], "Cuenta no autenticada");
  // Verificar que el ticket pueda ser reutilizable
  require(eventTickets[_tokenId].resellable, "Ticket no es reutilizable");
    // Verificar que el ticket no haya sido cancelado
  require(!eventTickets[_tokenId].refunded, "Ticket ha sido cancelado");
  // Verificar que el precio del ticket cumpla con el precio mínimo y máximo establecidos
  require(checkPriceEvent(_tokenId, _price), "El precio del ticket no cumple con el precio minimo y maximo establecidos");
  // Verificar que el límite de ventas no haya sido alcanzado
  require(eventTickets[_tokenId].sellCount < eventTickets[_tokenId].sellLimit, "Limite de ventas alcanzado");
   // Verificar que la fecha de expiración del ticket no haya vencido
    require(block.timestamp <= eventTickets[_tokenId].expirationTime, "Ticket ha vencido");
  // Incrementar el contador de veces vendido del ticket
  eventTickets[_tokenId].sellCount++;
  // Verificar que el ticket de evento no haya sido ya vendido
  require(eventTickets[_tokenId].owner != address(0), "Ticket ya ha sido vendido");
  // Verificar que el ticket de evento pertenezca al remitente
  require(ownerOf(_tokenId) == msg.sender, "Ticket no pertenece al remitente");
  // Establecer el precio del ticket de evento
  eventTickets[_tokenId].price = _price;
  // Establecer el dueño del ticket de evento como el remitente
  eventTickets[_tokenId].owner = msg.sender;
}

// Función para verificar que el precio del ticket cumpla con el precio mínimo y máximo establecidos
function checkPriceEvent(uint256 _tokenId, uint _price) public view returns (bool) {
  return (_price >= eventTickets[_tokenId].minPrice && _price <= eventTickets[_tokenId].maxPrice);
}

// Método para realizar la reventa de un ticket de servicio
function resellServiceTicket(uint256 _tokenId, uint _price) public {
    // Verificar que la cuenta del remitente esté autenticada
    require(authenticatedAccounts[msg.sender], "Cuenta no autenticada");
    // Verificar que el ticket pueda ser reutilizable
    require(serviceTickets[_tokenId].resellable, "Ticket no es reutilizable");
    // Verificar que el ticket no haya sido cancelado
    require(!serviceTickets[_tokenId].refunded, "Ticket ha sido cancelado");
    // Verificar que el precio del ticket cumpla con el precio mínimo y máximo establecidos
    require(checkPriceService(_tokenId, _price), "Precio del ticket no cumple con el precio minimo y maximo establecidos");
    // Verificar que el límite de ventas no haya sido alcanzado
    require(serviceTickets[_tokenId].sellCount < serviceTickets[_tokenId].sellLimit, "Limite de ventas alcanzado");
    // Verificar que la fecha de expiración del ticket no haya vencido
    require(block.timestamp <= serviceTickets[_tokenId].expirationTime, "Ticket ha vencido");
    // Incrementar el contador de veces vendido del ticket
    serviceTickets[_tokenId].sellCount++;
    // Verificar que el ticket de servicio no haya sido ya vendido
    require(serviceTickets[_tokenId].owner != address(0), "Ticket ya ha sido vendido");
    // Verificar que el ticket de servicio pertenezca al remitente
    require(ownerOf(_tokenId) == msg.sender, "Ticket no pertenece al remitente");
    // Establecer el precio del ticket de servicio
    serviceTickets[_tokenId].price = _price;
    // Establecer el dueño del ticket de servicio como el remitente
    serviceTickets[_tokenId].owner = msg.sender;
}

function checkPriceService(uint256 _tokenId, uint _price) public view returns (bool) {
    ServiceTicket memory serviceTicket = serviceTickets[_tokenId];
    return (_price >= serviceTicket.minPrice && _price <= serviceTicket.maxPrice);
}

// Contador para llevar el control de los IDs de los tickets de soporte
uint supportTicketCount = 0;

// Función para crear un nuevo ticket de soporte
function createSupportTicket(string memory _issue) public {
// Incrementa el contador de tickets de soporte
supportTicketCount++;
// Crea un nuevo ticket de soporte
supportTickets[supportTicketCount] = SupportTicket({
id: supportTicketCount,
user: msg.sender,
issue: _issue,
status: SupportStatus.Open,
timestamp: block.timestamp,
agent: address(0)
    });

    // Emite el evento SupportTicketCreated
    emit SupportTicketCreated(supportTicketCount, msg.sender, _issue, block.timestamp);
}

// Función para asignar un agente a un ticket de soporte
function assignAgentToTicket(uint _ticketId, address _agent) public {
// Verifica que el ticket exista
require(supportTickets[_ticketId].id == _ticketId, "Ticket does not exist");
// Asigna el agente al ticket
supportTickets[_ticketId].agent = _agent;
}

// Función para cambiar el estado de un ticket de soporte
function updateTicketStatus(uint _ticketId, SupportStatus _status) public {
// Verifica que el ticket exista
require(supportTickets[_ticketId].id == _ticketId, "Ticket does not exist");
// Cambia el estado del ticket
supportTickets[_ticketId].status = _status;
}

// Función para obtener un ticket de soporte
function getSupportTicket(uint _ticketId) public view returns (address, string memory, SupportStatus, uint) {
// Verifica que el ticket exista
require(supportTickets[_ticketId].id == _ticketId, "Ticket does not exist");
// Devuelve el ticket
return (supportTickets[_ticketId].user, supportTickets[_ticketId].issue, supportTickets[_ticketId].status, supportTickets[_ticketId].timestamp);
}

// Función para obtener todos los tickets de soporte
function getAllSupportTickets() public view returns (SupportTicket[] memory) {
    SupportTicket[] memory result = new SupportTicket[](supportTicketCount);
    for (uint i = 0; i < supportTicketCount; i++) {
        result[i] = supportTickets[i];
    }
    return result;
}

uint256 public couponCount = 0;

 function createCoupon(string memory _code, uint256 _discountPercentage, uint256 _expirationTime) public {
        // Verificar que el código del cupón no exista
        require(couponIdsByCode[_code] == 0, "Coupon code already exists");

        couponCount++;
        Coupon memory newCoupon = Coupon(couponCount, _code, _discountPercentage, _expirationTime, true);

        coupons[couponCount] = newCoupon;
        couponIdsByCode[_code] = couponCount;

        emit CouponCreated(couponCount, _code, _discountPercentage, _expirationTime);
    }

    function redeemCoupon(string memory _code, uint256 _eventId) public returns (uint256) {
    // Verificar que el código del cupón exista
    require(couponIdsByCode[_code] != 0, "Coupon code does not exist");

    uint256 couponId = couponIdsByCode[_code];
    Coupon memory coupon = coupons[couponId];

    // Verificar que el cupón esté activo
    require(coupon.isActive, "Coupon is not active");
    // Verificar que el cupón no haya expirado
    require(block.timestamp <= coupon.expirationTime, "Coupon has expired");

    // Calcular el nuevo precio del ticket con el descuento
    uint256 ticketPrice = eventTickets[_eventId].price;
    uint256 discountAmount = (ticketPrice * coupon.discountPercentage) / 100;

    // Desactivar el cupón después de su uso
    coupons[couponId].isActive = false;

    emit CouponRedeemed(couponId, msg.sender);

    // Devolver el nuevo precio del ticket con el descuento aplicado
    return ticketPrice - discountAmount;
}

 uint256 constant TICKET_SAFE_NFT_REWARD_POINTS = 100;

    // Función para redimir una recompensa con puntos
    function redeemReward(address user, uint256 rewardId) public {
        require(rewardId < rewards.length, "La recompensa no existe");
        require(userRewards[user].points >= rewards[rewardId].pointsCost, "Puntos insuficientes para redimir la recompensa");

        // Reducir los puntos del usuario según el costo de la recompensa
        userRewards[user].points -= rewards[rewardId].pointsCost;

        // Si los puntos son suficientes para redimir un NFT de Ticket Safe, otorga el NFT al usuario
        if (userRewards[user].points >= TICKET_SAFE_NFT_REWARD_POINTS) {
            // Asume que el token ID para el NFT de Ticket Safe es 1
            uint256 ticketSafeNftTokenId = 1;

            // Transfiere el NFT de Ticket Safe al usuario
            _mint(user, ticketSafeNftTokenId);
        }

        // Aquí puedes agregar la lógica para entregar la recompensa al usuario
        // Por ejemplo, emitir un evento para notificar que una recompensa ha sido redimida
        emit RewardRedeemed(user, rewardId);
    }
}
