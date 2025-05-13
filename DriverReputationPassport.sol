// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DriverReputationPassport {
    // Contract owner (admin)
    address public owner;
    
    // Mapping to track admin addresses
    mapping(address => bool) public admins;
    
    // Driver ID counter
    uint256 public driverIdCounter = 100000; // Starting from 100000 for 6-digit IDs
    
    // Events for important actions
    event DriverAdded(uint256 indexed driverId, string name);
    event VehicleAdded(uint256 indexed driverId, string regNumber);
    event AccidentAdded(uint256 indexed driverId, string location);
    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);

    // Driver basic information structure
    struct DriverInfo {
        string name;
        string dob;
        string mobile;
        string email;
        string licenseNumber;
        string permanentAddress;
        string bloodGroup;
        string vehicleType; // Truck, Car, Bike, Other
        string imageUrl;
        bool exists;
    }
    
    // Vehicle information structure
    struct VehicleInfo {
        string company;
        string model;
        string registrationNumber;
        string pucDates; // Could be array in more complex version
        string ownerName;
        string insuranceProvider;
        string policyNumber;
        string policyValidity;
        string insuranceType; // Comprehensive or Third-Party
        bool exists;
    }
    
    // Accident information structure
    struct AccidentInfo {
        uint256 dateTime; // Unix timestamp
        string location;
        string description;
        string cause;
        string caseStatus; // Open / Closed
        string claimStatus;
        string photoUrl;
        string firNumber;
        bool exists;
    }
    
    // Mappings to store all data
    mapping(uint256 => DriverInfo) public drivers;
    mapping(uint256 => VehicleInfo) public vehicles;
    mapping(uint256 => AccidentInfo[]) public accidents; // Array for multiple accidents
    
    // Modifier to restrict access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    // Modifier to restrict access to admins only
    modifier onlyAdmin() {
        require(admins[msg.sender] || msg.sender == owner, "Only admin can perform this action");
        _;
    }
    
    // Constructor sets the contract deployer as owner and first admin
    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
    }
    
    // Function to add new admin (only owner can do this)
    function addAdmin(address _admin) external onlyOwner {
        require(_admin != address(0), "Invalid address");
        admins[_admin] = true;
        emit AdminAdded(_admin);
    }
    
    // Function to remove admin (only owner can do this)
    function removeAdmin(address _admin) external onlyOwner {
        require(_admin != address(0), "Invalid address");
        admins[_admin] = false;
        emit AdminRemoved(_admin);
    }
    
    /**
     * @dev Adds a new driver and generates a 6-digit ID
     * @param _name Driver's full name
     * @param _dob Date of birth in string format
     * @param _mobile Contact mobile number
     * @param _email Email address
     * @param _licenseNumber Official license number
     * @param _permanentAddress Full permanent address
     * @param _bloodGroup Blood group (A+, B-, etc.)
     * @param _vehicleType Type of vehicle (Truck, Car, Bike, Other)
     * @param _imageUrl URL to driver's photo
     * @return driverId The generated 6-digit driver ID
     */
    function addDriver(
        string memory _name,
        string memory _dob,
        string memory _mobile,
        string memory _email,
        string memory _licenseNumber,
        string memory _permanentAddress,
        string memory _bloodGroup,
        string memory _vehicleType,
        string memory _imageUrl
    ) external onlyAdmin returns (uint256) {
        // Generate new driver ID
        uint256 driverId = driverIdCounter++;
        
        // Create and store new driver record
        drivers[driverId] = DriverInfo({
            name: _name,
            dob: _dob,
            mobile: _mobile,
            email: _email,
            licenseNumber: _licenseNumber,
            permanentAddress: _permanentAddress,
            bloodGroup: _bloodGroup,
            vehicleType: _vehicleType,
            imageUrl: _imageUrl,
            exists: true
        });
        
        emit DriverAdded(driverId, _name);
        return driverId;
    }
    
    /**
     * @dev Adds vehicle information for an existing driver
     * @param _driverId 6-digit driver ID
     * @param _company Vehicle manufacturer company
     * @param _model Vehicle model name
     * @param _registrationNumber Official registration number
     * @param _pucDates PUC certification dates
     * @param _ownerName Name on vehicle registration
     * @param _insuranceProvider Insurance company name
     * @param _policyNumber Insurance policy number
     * @param _policyValidity Policy validity dates
     * @param _insuranceType Type of insurance (Comprehensive/Third-Party)
     */
    function addVehicle(
        uint256 _driverId,
        string memory _company,
        string memory _model,
        string memory _registrationNumber,
        string memory _pucDates,
        string memory _ownerName,
        string memory _insuranceProvider,
        string memory _policyNumber,
        string memory _policyValidity,
        string memory _insuranceType
    ) external onlyAdmin {
        require(drivers[_driverId].exists, "Driver does not exist");
        
        vehicles[_driverId] = VehicleInfo({
            company: _company,
            model: _model,
            registrationNumber: _registrationNumber,
            pucDates: _pucDates,
            ownerName: _ownerName,
            insuranceProvider: _insuranceProvider,
            policyNumber: _policyNumber,
            policyValidity: _policyValidity,
            insuranceType: _insuranceType,
            exists: true
        });
        
        emit VehicleAdded(_driverId, _registrationNumber);
    }
    
    /**
     * @dev Records an accident for a driver
     * @param _driverId 6-digit driver ID
     * @param _dateTime Accident timestamp (Unix)
     * @param _location Location of accident
     * @param _description Detailed description
     * @param _cause Reason/cause of accident
     * @param _caseStatus Case status (Open/Closed)
     * @param _claimStatus Insurance claim status
     * @param _photoUrl URL to accident photos
     * @param _firNumber FIR/Police report number
     */
    function addAccident(
        uint256 _driverId,
        uint256 _dateTime,
        string memory _location,
        string memory _description,
        string memory _cause,
        string memory _caseStatus,
        string memory _claimStatus,
        string memory _photoUrl,
        string memory _firNumber
    ) external onlyAdmin {
        require(drivers[_driverId].exists, "Driver does not exist");
        
        accidents[_driverId].push(AccidentInfo({
            dateTime: _dateTime,
            location: _location,
            description: _description,
            cause: _cause,
            caseStatus: _caseStatus,
            claimStatus: _claimStatus,
            photoUrl: _photoUrl,
            firNumber: _firNumber,
            exists: true
        }));
        
        emit AccidentAdded(_driverId, _location);
    }
    
    /**
     * @dev Retrieves complete driver information
     * @param _driverId 6-digit driver ID
     * @return DriverInfo, VehicleInfo, and AccidentInfo array
     */
    function getDriverData(uint256 _driverId) external view returns (
        DriverInfo memory,
        VehicleInfo memory,
        AccidentInfo[] memory
    ) {
        require(drivers[_driverId].exists, "Driver does not exist");
        return (
            drivers[_driverId],
            vehicles[_driverId],
            accidents[_driverId]
        );
    }
    
    /**
     * @dev Gets basic driver information
     * @param _driverId 6-digit driver ID
     */
    function getDriverInfo(uint256 _driverId) external view returns (DriverInfo memory) {
        require(drivers[_driverId].exists, "Driver does not exist");
        return drivers[_driverId];
    }
    
    /**
     * @dev Gets vehicle information for a driver
     * @param _driverId 6-digit driver ID
     */
    function getVehicleInfo(uint256 _driverId) external view returns (VehicleInfo memory) {
        require(drivers[_driverId].exists, "Driver does not exist");
        return vehicles[_driverId];
    }
    
    /**
     * @dev Gets accident history for a driver
     * @param _driverId 6-digit driver ID
     */
    function getAccidentHistory(uint256 _driverId) external view returns (AccidentInfo[] memory) {
        require(drivers[_driverId].exists, "Driver does not exist");
        return accidents[_driverId];
    }
    
    /**
     * @dev Checks if a driver exists
     * @param _driverId 6-digit driver ID
     */
    function driverExists(uint256 _driverId) external view returns (bool) {
        return drivers[_driverId].exists;
    }
}