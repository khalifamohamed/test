pragma solidity ^0.4.18;
contract EnlistmentToContract {

    address owner; // A variable to store the address of the contract initalizer
    string landlord; 
    bool public locked = false; // boolean variable to define the state of apartment enlistment
    Enlistment enlistment; // An object of the struct Enlistment
    mapping(string => Offer) tenantOfferMap; // Key-Value mapping for both the offer and the aggrements
    mapping(string => AgreementDraft) tenantAgreementMap;

    function EnlistmentToContract(string landlordEmail, string streetName, int floorNr, int apartmentNr, int houseNr, int postalCode) public
    {
        // The function that creates the Enlistment inside the blockchain
        enlistment = Enlistment(streetName, floorNr, apartmentNr, houseNr, postalCode);
        landlord = landlordEmail;
        owner = msg.sender;
    }

    function getOwner() view public ownerOnly() returns (address) {
        // get the address of the contract initializer
        return owner;
    }

    function getLandlord() view public ownerOnly() returns (string) {
        // get the name of the property's landlord
        return landlord;
    }

    function getEnlistment() view public ownerOnly() returns (string, int, int, int, int) {
        // get the Enlisment Data
        return (enlistment.streetName, enlistment.floorNr, enlistment.apartmentNr, enlistment.houseNr, enlistment.postalCode);
    }

    enum OfferStatus {
        // Enum is a distinct type that consists of a set of named constants called the enumerator list
        // These are the states of the offer.
        PENDING,
        REJECTED,
        CANCELLED,
        ACCEPTED
    }

    enum AgreementStatus {
        //the states of the agreements.
        UNINITIALIZED, // internal
        PENDING,
        REJECTED,
        CONFIRMED,
        CANCELLED,
        LANDLORD_SIGNED,
        TENANT_SIGNED,
        COMPLETED
    }

    struct Enlistment
     // The Struct that contain the attributes of any Enlistment
     {
        string streetName;
        int floorNr;
        int apartmentNr;
        int houseNr;
        int postalCode;
    }

    struct Offer {
        // The Struct that contains the attributes of any Offer
        bool initialized;
        int amount;
        string tenantName;
        string tenantEmail;
        OfferStatus status;
    }

    struct AgreementDraft {
        // The Struct that contains the attributes of any Agreement
        string landlordName; // for simplicity, there is only one landlord
        string tenantName; // for simplicity, there is only one tenant and occupants are omitted
        string tenantEmail;
        int amount;
        uint leaseStart;
        uint handoverDate;
        uint leasePeriod;
        string otherTerms;
        string hash;
        string landlordSignedHash;
        string tenantSignedHash;
        AgreementStatus status;
    }

    modifier noActiveOffer(string tenantEmail) {
        // If the offer of the tenant was either not initialized, Rejected or cancelled. 
        require(tenantOfferMap[tenantEmail].initialized == false || tenantOfferMap[tenantEmail].status == OfferStatus.REJECTED || tenantOfferMap[tenantEmail].status == OfferStatus.CANCELLED);
        _;
    }

    modifier offerExists(string tenantEmail) {
        // Check if and exists with that tenantEmail.
        require(tenantOfferMap[tenantEmail].initialized == true);
        _;
    }

    modifier offerInStatus(OfferStatus status, string tenantEmail) {
        // Check to see if the offer is in the right state.
        require(tenantOfferMap[tenantEmail].status == status);
        _;
    }

    modifier offerCancellable(string tenantEmail) {
        // Check to see if the offer can be cancelled and it is not cancelled already nor rejected.
        var offerStatus = tenantOfferMap[tenantEmail].status;
        require(offerStatus == OfferStatus.PENDING || offerStatus == OfferStatus.ACCEPTED);
        var agreementStatus = tenantAgreementMap[tenantEmail].status;
        require(!(agreementStatus == AgreementStatus.CANCELLED || agreementStatus == AgreementStatus.TENANT_SIGNED || agreementStatus == AgreementStatus.COMPLETED));
        _;
    }

    modifier agreementCanBeSubmitted(string tenantEmail) {
        // Check if the agreement is not yet initialized and can be submitted.
        require(tenantAgreementMap[tenantEmail].status == AgreementStatus.UNINITIALIZED ||
        tenantAgreementMap[tenantEmail].status == AgreementStatus.REJECTED || tenantAgreementMap[tenantEmail].status == AgreementStatus.CANCELLED);
        _;
    }

    modifier agreementInStatus(AgreementStatus status, string tenantEmail) {
        // Check if the aggrement has the right status
        require(tenantAgreementMap[tenantEmail].status == status);
        _;
    }

    modifier agreementCancellable(string tenantEmail) {
        // Check to see if the offer can be cancelled and it is not cancelled already nor rejected.
        var agreementStatus = tenantAgreementMap[tenantEmail].status;
        require(!(agreementStatus == AgreementStatus.CANCELLED || agreementStatus == AgreementStatus.TENANT_SIGNED || agreementStatus == AgreementStatus.COMPLETED || agreementStatus == AgreementStatus.REJECTED));
        _;
    }

    modifier notLocked() {
        // Check to see if the state of the apratment is not Locked.
        require(!locked);
        _;
    }

    modifier ownerOnly() {
        // That means that when the owner will call the function with this modifier, the function will get executed and otherwise, an exception will be thrown.
        require(msg.sender == owner);
        _;
    }

    // what if the offer is in status PENDING and the tenant wants to send a new one?
    function sendOffer(int amount, string tenantName, string tenantEmail) payable public
        ownerOnly()
        noActiveOffer(tenantEmail)
        notLocked()
    {
        var offer = Offer({
            initialized: true,
            amount: amount,
            tenantName: tenantName,
            tenantEmail: tenantEmail,
            status: OfferStatus.PENDING
        });
        tenantOfferMap[tenantEmail] = offer;
    }

    function cancelOffer(string tenantEmail) payable public
        ownerOnly()
        offerExists(tenantEmail)
        offerCancellable(tenantEmail)
    {
        // Cancel Offer
        tenantOfferMap[tenantEmail].status = OfferStatus.CANCELLED;
        if (tenantAgreementMap[tenantEmail].status != AgreementStatus.UNINITIALIZED) {
            tenantAgreementMap[tenantEmail].status = AgreementStatus.CANCELLED;
        }
        locked = false;
    }

    function getOffer(string tenantEmail) view public ownerOnly() returns (bool, int, string, string, OfferStatus) {
        // Get Offer Details
        var o = tenantOfferMap[tenantEmail];
        return (o.initialized, o.amount, o.tenantName, o.tenantEmail, o.status);
    }

    function reviewOffer(bool result, string tenantEmail) payable public
        ownerOnly()
        offerExists(tenantEmail)
        offerInStatus(OfferStatus.PENDING, tenantEmail)
    {
        // Review Offer (Approve or Reject)
        tenantOfferMap[tenantEmail].status = result ? OfferStatus.ACCEPTED : OfferStatus.REJECTED;
    }

    function submitDraft(string tenantEmail, string landlordName, string agreementTenantName, string agreementTenantEmail,
        uint leaseStart, uint handoverDate, uint leasePeriod, string otherTerms, string hash) payable public
        ownerOnly()
        offerExists(tenantEmail)
        offerInStatus(OfferStatus.ACCEPTED, tenantEmail)
        agreementCanBeSubmitted(tenantEmail)
    {  //Submit the agreement with the two sides
        var amount = tenantOfferMap[tenantEmail].amount;
        tenantAgreementMap[tenantEmail] = AgreementDraft(landlordName,
            agreementTenantName, agreementTenantEmail,
            amount, leaseStart,
            handoverDate, leasePeriod,
            otherTerms, hash, "", "", AgreementStatus.PENDING);
    }

    // getAgreement functions:
    // can only return tuple of max 7 elements, otherwise throws "Stack too geep"
    // solution: splitted into multiple functions

    function getAgreementParticipants(string tenantEmail) view public ownerOnly() returns (string, string, string) {
        var a = tenantAgreementMap[tenantEmail];
        return (a.landlordName, a.tenantName, a.tenantEmail);
    }

    function getAgreementDetails(string tenantEmail) view public ownerOnly() returns (int, uint, uint, uint, string) {
        var a = tenantAgreementMap[tenantEmail];
        return (a.amount, a.leaseStart, a.handoverDate, a.leasePeriod, a.otherTerms);
    }

    function getAgreementHashes(string tenantEmail) view public ownerOnly() returns (string, string, string) {
        var a = tenantAgreementMap[tenantEmail];
        return (a.hash, a.landlordSignedHash, a.tenantSignedHash);
    }

    function getAgreementStatus(string tenantEmail) view public ownerOnly() returns (AgreementStatus) {
        var a = tenantAgreementMap[tenantEmail];
        return (a.status);
    }

    function reviewAgreement(string tenantEmail, bool result) payable public
        ownerOnly()
        offerExists(tenantEmail)
        offerInStatus(OfferStatus.ACCEPTED, tenantEmail)
        agreementInStatus(AgreementStatus.PENDING, tenantEmail)
        //Review The Agreement (Approve or Reject)
    {
        tenantAgreementMap[tenantEmail].status = result ? AgreementStatus.CONFIRMED : AgreementStatus.REJECTED;
    }

    function landlordSignAgreement(string tenantEmail, string landlordSignedHash) payable public
        ownerOnly()
        notLocked()
        offerExists(tenantEmail)
        offerInStatus(OfferStatus.ACCEPTED, tenantEmail)
        agreementInStatus(AgreementStatus.CONFIRMED, tenantEmail)
    {
        // The Landlord signs the Agreement
        tenantAgreementMap[tenantEmail].landlordSignedHash = landlordSignedHash;
        tenantAgreementMap[tenantEmail].status = AgreementStatus.LANDLORD_SIGNED;
        locked = true;
    }

    function tenantSignAgreement(string tenantEmail, string tenantSignedHash) payable public
        ownerOnly()
        offerExists(tenantEmail)
        offerInStatus(OfferStatus.ACCEPTED, tenantEmail)
        agreementInStatus(AgreementStatus.LANDLORD_SIGNED, tenantEmail)
    {
        // The Tenant signs the Agreement
        tenantAgreementMap[tenantEmail].tenantSignedHash = tenantSignedHash;
        tenantAgreementMap[tenantEmail].status = AgreementStatus.TENANT_SIGNED;
    }

    function cancelAgreement(string tenantEmail) payable public
        ownerOnly()
        agreementCancellable(tenantEmail)
    {
        // Cancel the agreement
        tenantAgreementMap[tenantEmail].status = AgreementStatus.CANCELLED;
        locked = false;
    }

    function receiveFirstMonthRent(string tenantEmail) payable public
        ownerOnly()
        offerExists(tenantEmail)
        offerInStatus(OfferStatus.ACCEPTED, tenantEmail)
        agreementInStatus(AgreementStatus.TENANT_SIGNED, tenantEmail)
    {
        // Pay the landlord the first month
        tenantAgreementMap[tenantEmail].status = AgreementStatus.COMPLETED;
    }
}
