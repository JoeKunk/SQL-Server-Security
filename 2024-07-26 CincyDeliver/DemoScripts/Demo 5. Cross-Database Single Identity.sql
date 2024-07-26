/*
DEMO 5 (Pending)

       What if you need to run a stored procedure across multiple databases.

	   Example: 
			Multi-national Forture 500 corporation has one DB per country
			Task: Create corp-level sales roll-up calcuations across all databases.
        
		Need a single security context across all databases that can be assigned permissons.
		Works only with on-premises databases on a single SQL Server

		Solution:
				Create identical signed certificate in all databases including Master
				Create users in each database from the certificate instead of login
				Assign minimum permissions to cert user in each database as appropriate.
				Run the stored procedure EXECUTE AS the login for the primary database.
        
		Demo Pending
*/
