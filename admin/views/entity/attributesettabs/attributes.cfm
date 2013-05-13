<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.attributeSet" type="any" />

<cfoutput>

	<cf_HibachiListingDisplay smartList="#rc.attributeSet.getAttributesSmartList()#" 
							   recordEditAction="admin:entity.editattribute" 
							   recordEditQueryString="attributeSetID=#rc.attributeSet.getAttributeSetID()#"
							   recordDetailAction="admin:entity.detailattribute"
							   recordDetailQueryString="attributeSetID=#rc.attributeSet.getAttributeSetID()#"
							   recordDeleteAction="admin:entity.deleteattribute"
							   recordDeleteQueryString="attributeSetID=#rc.attributeSet.getAttributeSetID()#&redirectAction=admin:entity.detailattributeset"
							   sortProperty="sortOrder"
							   sortContextIDColumn="attributeSetID"
							   sortContextIDValue="#rc.attributeSet.getAttributeSetID()#">
							      
		<cf_HibachiListingColumn propertyIdentifier="attributeCode" sort="true" search="true" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="attributeName" sort="true" search="true" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" filter="true" />
		<cf_HibachiListingColumn propertyIdentifier="attributeType.type" filter="true" />
	</cf_HibachiListingDisplay>
	
	<cf_HibachiActionCaller action="admin:entity.createattribute" class="btn" icon="plus" queryString="attributesetid=#rc.attributeset.getAttributeSetID()#" modal=true />
	
</cfoutput>
