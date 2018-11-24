'use strict';
/*This Class handle all the agreement operations but it requires totake data from the Property Enlistment Service Class first*/
const PropertyEnlistmentService = require('../services/PropertyEnlistmentService');
const log = require('../../server/logger');

/*Submit Agreement Function*
Requires the Data from Id and body of the agreement
*/
module.exports = {
  async submitAgreementDraft(req, res) {
    await PropertyEnlistmentService.submitAgreementDraft(req.params.id, req.body);

    log.info('Agreement draft submitted');
    res.status(201).send();
  },
/*Submit Agreement Function*
Requires the Enlistment Id and tenant Email
*/
  async getAgreement(req, res) {
    const agreement = await PropertyEnlistmentService.getAgreement(req.params.id, req.query.tenantEmail);

    res.json(agreement);
  },
/*Review Agreement Function*
Requires the Enlistment Id and tenant Email and the response whether true for Accepted or false for rejected
*/
  async reviewAgreement(req, res) {
    await PropertyEnlistmentService.reviewAgreement(req.params.id, req.body.tenantEmail, req.body.confirmed);

    log.info(`Agreement reviewed with resolution ${req.body.confirmed}`);
    res.status(200).send();
  },
/*Sign Agreement Function*
Requires the Enlistment Id and tenant Email the party and its signature hash
*/
  async signAgreement(req, res) {
    await PropertyEnlistmentService.signAgreement(req.params.id, req.body.tenantEmail, req.body.party, req.body.signatureHash);

    log.info(`Agreement signed by ${req.body.party}`);
    res.status(200).send();
  },
/*Cancel Agreement Function*
Requires the Enlistment Id and tenant Email
*/
  async cancelAgreement(req, res) {
    await PropertyEnlistmentService.cancelAgreement(req.params.id, req.body.tenantEmail);

    log.info(`Agreement cancelled`);

    res.status(200).send();
  },
/*Send Payment Function*
Requires the Enlistment Id and tenant Email to send the first month payment
*/
  async receiveFirstMonthRent(req, res) {
    await PropertyEnlistmentService.receiveFirstMonthRent(req.params.id, req.body.tenantEmail);

    log.info(`First month payment received`);
    res.status(200).send();
  }
};
