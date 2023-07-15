/*      AUTHOR: Joseph Kunk, Senior Software Architect at Dewpoint, Lansing MI USA. 
                LinkedIn:	joe-kunk-b926091
				Twitter:	@joekunk
				Mastodon:	@joekunk@techhub.social
				Email:		joekunk@gmail.com
*/

/*	For non-admins, SQL Server security is granted at the database level or lower
	What if you have a stored procedure that needs to use multiple databases?
	This can happen on external vendor interfaces

	Traditional database level permissions do not work ...
	Need to create one security context (SID) across all databases, but how?

	Strategy:
		1. Create a certificate in the master database.
		2. Export that certificate to a file with a password (don't lose the password!)
		3. Import the certificate into each database involved in the query
		4. Create the same user from that certificate in each database
		5. In each database, assign the needed permissions to that user
		6. Sign the stored procedure by the certificate
		7. Execute the stored procedure in the primary db as that user
		8. Any changes to the stored procedure require re-sign by the certificate
		   to validate that the change was authorized

		Since the user was created from the same certificate in each database,
		it is the same user and permissions across all databases will accumulate.
*/
