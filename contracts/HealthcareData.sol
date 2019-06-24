pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract HealthcareData{
    using SafeMath for uint256;
    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner; //This will be the government
    bool private operational = true;
    
    //PMJAY Identification number for family
    // mapping (uint => address[]) private familyMembers;
    // mapping (uint => uint256) private walletBalance; //This will be the insurance coverage per family ID
    mapping (address => uint256) private walletBalance;
    address[] private healthcareProviders; //empanelled hospitals 

    struct PHR{
        bytes32 id; //unique ID for each visit
        string metadata;  //url for how to access the data? OR Merkle Root of data
        uint treatmentCode; //upto 1350 
        address provider;
        address beneficiary; 
        bool isClaimed;
    }
    mapping(bytes32 => PHR) PHRDetails;
    mapping (address => PHR[]) PHRHistory;
    //A mapping to store the cost of the treatment
    mapping(uint => uint256) treatmentCost;
    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    event providerRegistered(address healthcareProviderAddress);
    event newPHR(address provider, address beneficiary, uint256 timestamp,uint treatmentCode,string metadata, bytes32 id);
    event PaidPHR(address provider, address beneficiary, uint256 timestamp,uint treatmentCode,string metadata, bytes32 id);

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor () public {
        contractOwner = msg.sender;
        // healthcareProviders.push(msg.sender);
        //AMOUNT OF FUNDS GOVERNMENT HAS PROMISED TO PROVIDE
        walletBalance[contractOwner] = 20 ether;
        //SETUP MAPPING WITH FAKE DATA
        treatmentCost[0]=0.0001 ether;
        treatmentCost[1]=0.0002 ether;
        treatmentCost[2]=0.0002 ether;
    }


    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.


    modifier requireIsOperational() 
    {
        require(operational, "Contract is currently not operational");
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requirePHRProvider(bytes32 id){
        require(PHRDetails[id].provider==tx.origin,"Only the healthcare provider can call this function");
        _;
    }
    modifier requireRegisteredProvider(){
        bool isRegistered = false;
        for(uint256 i=0;i<healthcareProviders.length;i++){
            if(healthcareProviders[i]==msg.sender){
                 isRegistered = true;
            }
        }
        require(isRegistered==true,"Not a valid healthcare provider");
        _;
    }
    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() public view returns (bool){
        return operational;
    }

    function setOperatingStatus (bool mode) external requireContractOwner {
        require(mode != operational, "New mode should be different from current mode");
        operational = mode;
    }

    //Unique hash value for a phr
    function getTreatmentKey
                        (
                            address _provider,
                            uint _treatmentCode,
                            uint256 _timestamp,
                            string _metadata
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(_provider, _treatmentCode, _timestamp,_metadata));
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/
    function addBeneficiary(address beneficiaryAddress) public requireContractOwner{
        // require(msg.value>=0.005 ether,"Each family must get 5 lakh coverage");
        walletBalance[contractOwner].sub(0.005 ether);
        walletBalance[beneficiaryAddress]=0.005 ether;
    }

    //For now only the Govt can add new healthcare Providers but this can modified for
    // a voting m of n voting system
    function registerHealthcareProvider (address _providerAddress) external requireContractOwner{
        healthcareProviders.push(_providerAddress);
        walletBalance[_providerAddress] = 0;
        emit providerRegistered(_providerAddress);
    }

    //Get a list of all healthcare Providers
    function getHealthcareProviders() external view requireIsOperational returns (address[]){
        return healthcareProviders;
    }

    
    function createPHR 
                    (
                        address _provider,
                        uint256 _timestamp,
                        address _beneficiary,
                        uint _treatmentCode,
                        string _metadata
                    )
                    external
                    requireIsOperational
    {
        bytes32 TreatmentKey = getTreatmentKey(_provider,_treatmentCode,_timestamp,_metadata);
        bytes32 PHRId = keccak256(abi.encodePacked(TreatmentKey,_beneficiary));
      
        PHRDetails[PHRId] = PHR({
            id: PHRId,
            metadata: _metadata,
            treatmentCode:_treatmentCode,
            provider:_provider,
            beneficiary:_beneficiary,
            isClaimed:false
        });
        incrementBalance(PHRId);
        PHRHistory[_beneficiary].push(PHRDetails[PHRId]);
        emit newPHR(_provider,_beneficiary,_timestamp,_treatmentCode,_metadata,PHRId);
    }


    function incrementBalance
                            (
                                bytes32 _id
                            ) 
                            private requirePHRProvider(_id)
    {
        PHR currPHR = PHRDetails[_id];
        require(currPHR.isClaimed!=true,"Insurance already claimed for this PHR");
        uint256 claimAmount = treatmentCost[currPHR.treatmentCode];
        require(walletBalance[currPHR.beneficiary]>claimAmount);
        walletBalance[currPHR.beneficiary].sub(claimAmount);
        walletBalance[currPHR.provider].add(claimAmount);
    }
    function fetchPHRs(address _beneficiary) external requireRegisteredProvider{

    }
    // function creditProvider
    //                         (
    //                             address providerAddress
    //                         )
    //                         requireContractOwner
    //                         payable
    // {   
    //    require(msg.value> walletBalance[providerAddress],"Not sufficient amount to cover cost");
    //     walletBalance
    // }
}