/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio.controller;

import java.util.ArrayList;

/**
 *
 * @author sheng
 */
public class OrganizationController {
    
    public static boolean CreateOrg(eventio.domain.Organization o) {
        return eventio.da.Organization.addOrganization(o);
    }
    
    public static eventio.domain.Organization getOrganizer(int orgId) {
        return eventio.da.Organization.getOrganization(orgId);
    }
    
    public static ArrayList<eventio.domain.Organization> getAllOrganization() {
        return eventio.da.Organization.getOrganizations();
    }
}
