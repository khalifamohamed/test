'use strict';

const PropertyEnlistmentService = require('../services/PropertyEnlistmentService');
const log = require('../../server/logger');
/*
	Send Offer Function Requires the Enlistment Id and the offer body {Tenant Name, Amount, Tenant Email}
*/
module.exports = {
  async sendOffer(req, res) {
    await PropertyEnlistmentService.sendOffer(req.params.id, req.body);

    log.info('Offer received');
    res.status(201).send();
  },
/*
	Get Offer Function Returns a specific offer based on the Enlistment Id and the tenant Email
*/
  async getOffer(req, res) {
    const offer = await PropertyEnlistmentService.getOffer(req.params.id, req.query.tenantEmail);

    res.json(offer);
  },
/*
	Cancel Offer Function cancels a specific offer based on who sent it (Tenant Email) and to which apartment (Enlistment Id)
*/
  async cancelOffer(req, res) {
    await PropertyEnlistmentService.cancelOffer(req.params.id, req.body.tenantEmail);

    log.info(`Offer cancelled`);

    res.status(200).send();
  },
/*
	Review Offer Function Requires the Enlistment Id and the offer body and the review value whether true or false
*/
  async reviewOffer(req, res) {
    await PropertyEnlistmentService.reviewOffer(req.params.id, req.body.tenantEmail, req.body.approved);

    log.info(`Offer reviewed with resolution ${req.body.approved}`);

    res.status(200).send();
  }
};
