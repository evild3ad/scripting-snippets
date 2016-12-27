/* SQL to convert a Triforce ANJP USN Journal database to a Gource custom log
     by ryan@obsidianforensics.com

Updated by mwilling@evild3ad.com (ANJP-v3.13.0 201509141000, Gource v0.42)

https://www.gettriforce.com/product/anjp-free/
https://www.gettriforce.com/product/triforce-anjp/
http://gource.io/

Usage: sqlite3.exe usn.db < USN_to_Gource.sql > usn.log

Convert the human-friendly timestamp to epoch seconds:   */
SELECT CAST(round((JULIANDAY(ur_datetime)-2440587.5)*86400,0) as integer),
  'USN', -- gource needs a 'User', so I set it statically to 'USN'
  CASE ur_reason_s  -- gource supports three file 'update types':
    WHEN 'File_Create' THEN 'A'       -- 'A' for adding a file
    WHEN 'File_Delete,Close' THEN 'D' -- 'D' for deleting
    ELSE 'M'                          -- and 'M' for modifying 
  END,
REPLACE(ur_fullname, '\', '/') -- swap the backslashes for forward slashes 
FROM usn_events_report          -- this is a view in the Triforce ANJP DB
ORDER BY ur_datetime ASC;       -- order by timestamp