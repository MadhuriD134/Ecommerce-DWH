import pandas as pd
import time
from google.cloud import bigquery as bq
from google.cloud import storage
from google.cloud.bigquery import LoadJobConfig
import my_module  
import cs_env


def Upload_CSV(file_name, my_dataset, my_table):
    client = bq.Client()
    job_config = bq.LoadJobConfig(
        source_format=bq.SourceFormat.CSV,
        skip_leading_rows=1,
        allow_quoted_newlines=True
    )
    uri=f'gs://customer_service_md/{file_name}'
    table_id=f"vf-grp-gbissdbx-dev-1.{my_dataset}.{my_table}"
    #print(f"uri-{uri} \n table_id={table_id}") 
    job=client.load_table_from_uri(uri,table_id,job_config=job_config)
    while job.state != "DONE" :
        time.sleep(2)
        job.reload()
        print(job.state)
	
    job.result()
    table=client.get_table(table_id)
    print("Loaded{} rows and {} columns to {}".format(table.num_rows, len(table.schema), table_id))
    
storageClient=storage.Client()
bucket=storageClient.bucket(my_module.src_bucket_name)
blob=bucket.blob('file_list.txt')
assert blob.exists()
data=blob.download_as_string()
with blob.open("r") as f:
    csvfiles=f.readlines()
#print(files)
num_of_files=len(csvfiles)

for i in range(0,num_of_files) :
    csvfile=csvfiles[i][:len(csvfiles[i])-1:]
    table_name=csvfile[ : len(csvfile)-4 ] 
    print(f" {csvfile}, {cs_env.staging_dataset}, { table_name } ") 
    Upload_CSV(csvfile, cs_env.staging_dataset , table_name  )

---------------------------------------------
import pandas as pd
import time
from google.cloud import bigquery as bq
from google.cloud.bigquery import LoadJobConfig
import cs_env

def Upload_CSV(file_name, my_dataset, my_table):
    
    client = bq.Client()

    job_config = bq.LoadJobConfig(
        source_format=bq.SourceFormat.CSV,
        skip_leading_rows=1,
        allow_quoted_newlines=True
    )

    uri=f'gs://customer_service_md/{file_name}'
    table_id=f"vf-grp-gbissdbx-dev-1.{my_dataset}.{my_table}"

    job=client.load_table_from_uri(uri,table_id,job_config=job_config)

    while job.state != "DONE" :
        time.sleep(2)
        job.reload()
        print(job.state)
	
    job.result()

    table=client.get_table(table_id)
    print("Loaded{} rows and {} columns to {}".format(table.num_rows, len(table.schema), table_id))
 
#Source_Data_Load()
Upload_CSV("Customer.csv",cs_env.staging_dataset, "Customer")
Upload_CSV("Product.csv",cs_env.staging_dataset,"Product")
Upload_CSV("Inventory.csv",cs_env.staging_dataset,"Inventory")
Upload_CSV("Order.csv",cs_env.staging_dataset,"Order")
Upload_CSV("Order_Item.csv",cs_env.staging_dataset,"Order_Item")

client = bq.Client()
#Start Loading DWH Tables  
dwh_load_query="""
call `vf-grp-gbissdbx-dev-1.customer_service.SP_Load_DWH`()
"""

query_job = client.query (
				dwh_load_query,
				Location='US',
				job_config=bq.QueryJobConfig(maximum_bytes_billed=50_000_000),
				job_id_prefix='load_dwh'
)

query_job.result()
				
---------------------------------

import pandas as pd
import time
from google.cloud import bigquery as bq
from google.cloud import storage
from google.cloud.bigquery import LoadJobConfig
import my_module
import cs_env

"""Start of Upload_CSV function
This function reads a file and loads it into BQ table """
def Upload_CSV(file_name, my_dataset, my_table):
    client = bq.Client()
    job_config = bq.LoadJobConfig(
        source_format=bq.SourceFormat.CSV,
        skip_leading_rows=1,
        allow_quoted_newlines=True
    )
    uri=f'gs://customer_service_md/{file_name}'
    table_id=f"vf-grp-gbissdbx-dev-1.{my_dataset}.{my_table}"
    #print(f"uri-{uri} \n table_id={table_id}") 
    job=client.load_table_from_uri(uri,table_id,job_config=job_config)
    while job.state != "DONE" :
        time.sleep(2)
        job.reload()
        print(f"{job.state}\n")
	
    job.result()
    table=client.get_table(table_id)
    print("Loaded {} rows and {} columns to {}".format(table.num_rows, len(table.schema), table_id))
#End of Upload_CSV


#Main Code starts Here    
storageClient=storage.Client()
bucket=storageClient.bucket(cs_env.src_bucket_name)
#file_list.txt file will have a list of files that needs to be loaded into Staging area.
blob=bucket.blob('file_list.txt')
assert blob.exists()
data=blob.download_as_string()
print("Reading files list from file_list.txt")
with blob.open("r") as f:
    csvfiles=f.readlines()  #csvfiles will have a list of all files mentioned in the file_list.txt
#print(files)
num_of_files=len(csvfiles)

print("Looping through the files and loading then into BQ one by one")
#Loop through the files and load then into BQ one by one; by calling Upload_CSV function
for i in range(0,num_of_files) :
    csvfile=csvfiles[i][:len(csvfiles[i])-1:]
    table_name=csvfile[ : len(csvfile)-4 ]
    #print(file)
    #print(len(file))
    print(f"{csvfile}, {cs_env.staging_dataset}, { table_name } ") 
    Upload_CSV(csvfile, cs_env.staging_dataset , table_name  )
    
print("We have loaded all the files into BQ Staging area.")    
"""Now the data is available into staging area. Start loading that into DWH by calling Stored-Procedure SP_Load_DWH.
As this is BQ to BQ data transformation; its easy in SQL"""

print("Calling SP to load data into DWH") 
client = bq.Client(project='vf-grp-gbissdbx-dev-1')
#Start Loading DWH Tables  
dwh_load_query="""
call `vf-grp-gbissdbx-dev-1.customer_service.SP_Load_DWH`()
"""
  
query_job = client.query ( dwh_load_query )
print(query_job.result())
print("DWH Load is complete.") 
