/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
	}
	
	public void function isAbleToCreateNewFulfillmentBatchTest(){
		//Get a new batch
		var fulfillmentBatch = request.slatwallScope.newEntity( 'fulfillmentBatch' );
		var processObject = fulfillmentBatch.getProcessObject( 'Create' );
		
		//Create a batch item and add an orderFulfillment
		var orderFulfillment = request.slatwallScope.newEntity( 'orderFulfillment' );
		var fulfillmentBatchItem = request.slatwallScope.newEntity( 'fulfillmentBatchItem' );
		fulfillmentBatchItem.setOrderFulfillment(orderFulfillment);
		
		//Set the others
		var account = request.slatwallScope.newEntity('account');
		var description = "This is a fulfillment batch description";
		
		//Add the fulfillment batch
		processObject.setFulfillmentBatchItems([fulfillmentBatchItem]);
		processObject.setAssignedAccount(account);
		processObject.setDescription(description);
		
		var result = false;
		//Has a description
		assertEquals(processObject.getDescription(), description);
		
		//Has a batch item
		assertEquals(processObject.getFulfillmentBatchItems()[1], fulfillmentBatchItem);
		
		//Has an assigned account
		assertEquals(processObject.getAssignedAccount(), account);
		
	}
	
	public void function isAbleToCreateNewFulfillmentBatchAutoPopulateTest(){
		
		//Get the process object
		var fulfillmentBatch = request.slatwallScope.newEntity( 'fulfillmentBatch' );
		fulfillmentBatch.setFulfillmentBatchID("123456");
		var processObject = fulfillmentBatch.getProcessObject( 'Create' );
		
		//Find a random location id to use for population
		var locationID = request.slatwallScope.getService("LocationService").getLocationCollectionList().getRecords()[1]['locationID'];
		var location = request.slatwallScope.getService("LocationService").getLocationByLocationID(locationID);
		
		//Find a random account id to use for population
		var accountID = request.slatwallScope.getService("AccountService").getAccountCollectionList().getRecords()[1]['accountID'];
		var account = request.slatwallScope.getService("AccountService").getAccountByAccountID(accountID);
		var description = "This is a fulfillment batch description";
		
		//*** Don't populate this time as it needs to happen automatically.
		//Test auto populate using the found data. It should find those entities while populating and put the objects into the process object.
		
		var data = {
			"locationIDList": location.getLocationID(),
			"assignedAccountID": account.getAccountID(),
			"description": "This is another test description"
		};
		
		//populate the data.
		processObject.populate(data);
		
		//Has the populated simple description
		assertEquals(processObject.getDescription(), data.description);
		
		//Has a populated simple location
		assertEquals(processObject.getLocationIDList(), data.locationIDList);
		
		//Has an assigned simple account
		assertEquals(processObject.getAssignedAccountID(), data.assignedAccountID);
		
		//Has a populated object based location
		assertEquals(processObject.getLocations()[1].getLocationID(), data.locationIDList);
		
		//Has an assigned object based account so auto populated
		assertEquals(processObject.getAssignedAccount().getAccountID(), data.assignedAccountID);
		
	}
	
	public void function isAbleToCreateWithSelectedOrderFulfillmentIDListTest(){
		
		//Get the process object
		var fulfillmentBatch = request.slatwallScope.newEntity( 'fulfillmentBatch' );
		fulfillmentBatch.setFulfillmentBatchID("123456");
		var processObject = fulfillmentBatch.getProcessObject( 'Create' );
		
		//Find a random location id to use for population
		var locationID = request.slatwallScope.getService("LocationService").getLocationCollectionList().getRecords()[1]['locationID'];
		var location = request.slatwallScope.getService("LocationService").getLocationByLocationID(locationID);
		
		//Find a random account id to use for population
		var accountID = request.slatwallScope.getService("AccountService").getAccountCollectionList().getRecords()[1]['accountID'];
		var account = request.slatwallScope.getService("AccountService").getAccountByAccountID(accountID);
		var description = "This is a fulfillment batch description";
		
		//Get some random orderFulfillments from Slatwall to use
		var orderFulfillmentsForTesting = [];
		for (var i = 1; i<=5; i++){
			data = {
				orderFulfillmentID: "#now()#12345678-" & i
			};
			var orderFulfillment = createPersistedTestEntity("OrderFulfillment", data);
			arrayAppend(orderFulfillmentsForTesting, orderFulfillment);
		}
		//Create the orderFulfillmentIDList;
		orderFulfillmentIDList = "";
		for (var orderFulfillment in orderFulfillmentsForTesting){
			orderFulfillmentIDList = listAppend(orderFulfillmentIDList, orderFulfillment.getOrderFulfillmentID());
		}
		
		//*** Don't populate this time as it needs to happen automatically including the idList
		//Test auto populate using the found data. It should find those entities while populating and put the objects into the process object.
		
		var data = {
			"locationIDList"= location.getLocationID(),
			"assignedAccountID"= account.getAccountID(),
			"description"= "This is another test description",
			"orderFulfillmentIDList"= orderFulfillmentIDList
		};
		
		//populate the data.
		processObject.populate(data);
		processObject.setOrderFulfillmentIDList(data.orderFulfillmentIDList);
		
		//Has the populated simple description
		assertEquals(processObject.getDescription(), data.description);
		
		//Has a populated simple location
		assertEquals(processObject.getLocationIDList(), data.locationIDList);
		
		//Has an assigned simple account
		assertEquals(processObject.getAssignedAccountID(), data.assignedAccountID);
		
		//Has a populated object based location
		assertEquals(processObject.getLocations()[1].getLocationID(), data.locationIDList);
		
		//Has an assigned object based account so auto populated
		assertEquals(processObject.getAssignedAccount().getAccountID(), data.assignedAccountID);
		
		//Call to generate the batchItems from the fulfillment list
		processObject.getFulfillmentBatchItemsByOrderFulfillmentIDList();
		
		//Should have 5 fulfillmentBatchItem
		assertEquals(5, arrayLen(processObject.getFulfillmentBatchItems()), "Should have at least one fulfillmentBatchItem");
	}
}
