/*
SETUP

*/

-- Restore the sample database so can see all security changes live

-- Create database AdventureWorks manually in SSMS first

USE [master]
ALTER DATABASE [AdventureWorks2012] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

RESTORE DATABASE [AdventureWorks2012] 
	FROM  DISK = N'C:\Temp\AdventureWorks2012.bak' WITH  FILE = 1  
	,MOVE N'AdventureWorks2012' 
		TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2012.mdf'
	,MOVE N'AdventureWorks2012_log' 
		TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2012_log.ldf'
	,NOUNLOAD
	,REPLACE
	,STATS = 10

ALTER DATABASE [AdventureWorks2012] SET MULTI_USER

GO

/* 

10 percent processed.
20 percent processed.
30 percent processed.
40 percent processed.
50 percent processed.
60 percent processed.
70 percent processed.
80 percent processed.
90 percent processed.
100 percent processed.
Processed 24184 pages for database 'AdventureWorks2012', file 'AdventureWorks2012' on file 1.
Processed 2 pages for database 'AdventureWorks2012', file 'AdventureWorks2012_log' on file 1.
Converting database 'AdventureWorks2012' from version 706 to the current version 904.
Database 'AdventureWorks2012' running the upgrade step from version 706 to version 770.
Database 'AdventureWorks2012' running the upgrade step from version 770 to version 771.
Database 'AdventureWorks2012' running the upgrade step from version 771 to version 772.
Database 'AdventureWorks2012' running the upgrade step from version 772 to version 773.
Database 'AdventureWorks2012' running the upgrade step from version 773 to version 774.
Database 'AdventureWorks2012' running the upgrade step from version 774 to version 775.
Database 'AdventureWorks2012' running the upgrade step from version 775 to version 776.
Database 'AdventureWorks2012' running the upgrade step from version 776 to version 777.
Database 'AdventureWorks2012' running the upgrade step from version 777 to version 778.
Database 'AdventureWorks2012' running the upgrade step from version 778 to version 779.
Database 'AdventureWorks2012' running the upgrade step from version 779 to version 780.
Database 'AdventureWorks2012' running the upgrade step from version 780 to version 781.
Database 'AdventureWorks2012' running the upgrade step from version 781 to version 782.
Database 'AdventureWorks2012' running the upgrade step from version 782 to version 801.
Database 'AdventureWorks2012' running the upgrade step from version 801 to version 802.
Database 'AdventureWorks2012' running the upgrade step from version 802 to version 803.
Database 'AdventureWorks2012' running the upgrade step from version 803 to version 804.
Database 'AdventureWorks2012' running the upgrade step from version 804 to version 805.
Database 'AdventureWorks2012' running the upgrade step from version 805 to version 806.
Database 'AdventureWorks2012' running the upgrade step from version 806 to version 807.
Database 'AdventureWorks2012' running the upgrade step from version 807 to version 808.
Database 'AdventureWorks2012' running the upgrade step from version 808 to version 809.
Database 'AdventureWorks2012' running the upgrade step from version 809 to version 810.
Database 'AdventureWorks2012' running the upgrade step from version 810 to version 811.
Database 'AdventureWorks2012' running the upgrade step from version 811 to version 812.
Database 'AdventureWorks2012' running the upgrade step from version 812 to version 813.
Database 'AdventureWorks2012' running the upgrade step from version 813 to version 814.
Database 'AdventureWorks2012' running the upgrade step from version 814 to version 815.
Database 'AdventureWorks2012' running the upgrade step from version 815 to version 816.
Database 'AdventureWorks2012' running the upgrade step from version 816 to version 817.
Database 'AdventureWorks2012' running the upgrade step from version 817 to version 818.
Database 'AdventureWorks2012' running the upgrade step from version 818 to version 819.
Database 'AdventureWorks2012' running the upgrade step from version 819 to version 820.
Database 'AdventureWorks2012' running the upgrade step from version 820 to version 821.
Database 'AdventureWorks2012' running the upgrade step from version 821 to version 822.
Database 'AdventureWorks2012' running the upgrade step from version 822 to version 823.
Database 'AdventureWorks2012' running the upgrade step from version 823 to version 824.
Database 'AdventureWorks2012' running the upgrade step from version 824 to version 825.
Database 'AdventureWorks2012' running the upgrade step from version 825 to version 826.
Database 'AdventureWorks2012' running the upgrade step from version 826 to version 827.
Database 'AdventureWorks2012' running the upgrade step from version 827 to version 828.
Database 'AdventureWorks2012' running the upgrade step from version 828 to version 829.
Database 'AdventureWorks2012' running the upgrade step from version 829 to version 830.
Database 'AdventureWorks2012' running the upgrade step from version 830 to version 831.
Database 'AdventureWorks2012' running the upgrade step from version 831 to version 832.
Database 'AdventureWorks2012' running the upgrade step from version 832 to version 833.
Database 'AdventureWorks2012' running the upgrade step from version 833 to version 834.
Database 'AdventureWorks2012' running the upgrade step from version 834 to version 835.
Database 'AdventureWorks2012' running the upgrade step from version 835 to version 836.
Database 'AdventureWorks2012' running the upgrade step from version 836 to version 837.
Database 'AdventureWorks2012' running the upgrade step from version 837 to version 838.
Database 'AdventureWorks2012' running the upgrade step from version 838 to version 839.
Database 'AdventureWorks2012' running the upgrade step from version 839 to version 840.
Database 'AdventureWorks2012' running the upgrade step from version 840 to version 841.
Database 'AdventureWorks2012' running the upgrade step from version 841 to version 842.
Database 'AdventureWorks2012' running the upgrade step from version 842 to version 843.
Database 'AdventureWorks2012' running the upgrade step from version 843 to version 844.
Database 'AdventureWorks2012' running the upgrade step from version 844 to version 845.
Database 'AdventureWorks2012' running the upgrade step from version 845 to version 846.
Database 'AdventureWorks2012' running the upgrade step from version 846 to version 847.
Database 'AdventureWorks2012' running the upgrade step from version 847 to version 848.
Database 'AdventureWorks2012' running the upgrade step from version 848 to version 849.
Database 'AdventureWorks2012' running the upgrade step from version 849 to version 850.
Database 'AdventureWorks2012' running the upgrade step from version 850 to version 851.
Database 'AdventureWorks2012' running the upgrade step from version 851 to version 852.
Database 'AdventureWorks2012' running the upgrade step from version 852 to version 853.
Database 'AdventureWorks2012' running the upgrade step from version 853 to version 854.
Database 'AdventureWorks2012' running the upgrade step from version 854 to version 855.
Database 'AdventureWorks2012' running the upgrade step from version 855 to version 856.
Database 'AdventureWorks2012' running the upgrade step from version 856 to version 857.
Database 'AdventureWorks2012' running the upgrade step from version 857 to version 858.
Database 'AdventureWorks2012' running the upgrade step from version 858 to version 859.
Database 'AdventureWorks2012' running the upgrade step from version 859 to version 860.
Database 'AdventureWorks2012' running the upgrade step from version 860 to version 861.
Database 'AdventureWorks2012' running the upgrade step from version 861 to version 862.
Database 'AdventureWorks2012' running the upgrade step from version 862 to version 863.
Database 'AdventureWorks2012' running the upgrade step from version 863 to version 864.
Database 'AdventureWorks2012' running the upgrade step from version 864 to version 865.
Database 'AdventureWorks2012' running the upgrade step from version 865 to version 866.
Database 'AdventureWorks2012' running the upgrade step from version 866 to version 867.
Database 'AdventureWorks2012' running the upgrade step from version 867 to version 868.
Database 'AdventureWorks2012' running the upgrade step from version 868 to version 869.
Database 'AdventureWorks2012' running the upgrade step from version 869 to version 875.
Database 'AdventureWorks2012' running the upgrade step from version 875 to version 876.
Database 'AdventureWorks2012' running the upgrade step from version 876 to version 877.
Database 'AdventureWorks2012' running the upgrade step from version 877 to version 878.
Database 'AdventureWorks2012' running the upgrade step from version 878 to version 879.
Database 'AdventureWorks2012' running the upgrade step from version 879 to version 880.
Database 'AdventureWorks2012' running the upgrade step from version 880 to version 881.
Database 'AdventureWorks2012' running the upgrade step from version 881 to version 882.
Database 'AdventureWorks2012' running the upgrade step from version 882 to version 883.
Database 'AdventureWorks2012' running the upgrade step from version 883 to version 884.
Database 'AdventureWorks2012' running the upgrade step from version 884 to version 885.
Database 'AdventureWorks2012' running the upgrade step from version 885 to version 886.
Database 'AdventureWorks2012' running the upgrade step from version 886 to version 887.
Database 'AdventureWorks2012' running the upgrade step from version 887 to version 888.
Database 'AdventureWorks2012' running the upgrade step from version 888 to version 889.
Database 'AdventureWorks2012' running the upgrade step from version 889 to version 890.
Database 'AdventureWorks2012' running the upgrade step from version 890 to version 891.
Database 'AdventureWorks2012' running the upgrade step from version 891 to version 892.
Database 'AdventureWorks2012' running the upgrade step from version 892 to version 893.
Database 'AdventureWorks2012' running the upgrade step from version 893 to version 894.
Database 'AdventureWorks2012' running the upgrade step from version 894 to version 895.
Database 'AdventureWorks2012' running the upgrade step from version 895 to version 896.
Database 'AdventureWorks2012' running the upgrade step from version 896 to version 897.
Database 'AdventureWorks2012' running the upgrade step from version 897 to version 898.
Database 'AdventureWorks2012' running the upgrade step from version 898 to version 899.
Database 'AdventureWorks2012' running the upgrade step from version 899 to version 900.
Database 'AdventureWorks2012' running the upgrade step from version 900 to version 901.
Database 'AdventureWorks2012' running the upgrade step from version 901 to version 902.
Database 'AdventureWorks2012' running the upgrade step from version 902 to version 903.
Database 'AdventureWorks2012' running the upgrade step from version 903 to version 904.
RESTORE DATABASE successfully processed 24186 pages in 1.094 seconds (172.712 MB/sec).

Completion time: 2023-03-23T15:33:46.0425518-04:00
*/

