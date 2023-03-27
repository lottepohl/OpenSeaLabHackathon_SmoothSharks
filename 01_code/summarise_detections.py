import pandas as pd
import numpy as np

reciever_detections=pd.read_csv(r"C:\Users\wout.decrop\project_environment\hackaton\OpenSeaLabHackathon_SmoothSharks\00_data\01_acoustic_detections\receiver_deployments.csv")
shark_detections=pd.read_csv(r"C:\Users\wout.decrop\project_environment\hackaton\OpenSeaLabHackathon_SmoothSharks\00_data\01_acoustic_detections\sharks_detections.csv")

shark_detections=shark_detections.loc[shark_detections['sensor_unit'] == "Meters"]

# shark_detections.groupby(['station_name','acoustic_tag_id'])['parameter']
parameters=shark_detections.groupby(['station_name']).agg({'parameter': ['mean', 'min', 'max']})
parameters
parameters.to_csv(r"C:\Users\wout.decrop\project_environment\hackaton\OpenSeaLabHackathon_SmoothSharks\00_data\01_acoustic_detections\water_level_parameter.csv")
df=shark_detections



df['Group'] = pd.cut(df['parameter'], bins=[0, 10, 20, 30, 40, 50], include_lowest=True)
df['Group'] 
# group by the 'Group' column and count the number of parameters in each group
grouped_df = df.groupby(['station_name','Group'])['parameter'].agg(['count'])

a=grouped_df.groupby(['station_name'], group_keys=False).apply(lambda x: x['count'] / x['count'].sum()).sort_index().rename("percentage")
a
# grouped_df.groupby(['station_name'], group_keys=False)["count"].apply(lambda x: x['count'] / x['count'].sum()).sort_index().rename("percentage")


a.to_csv(r"C:\Users\wout.decrop\project_environment\hackaton\OpenSeaLabHackathon_SmoothSharks\00_data\01_acoustic_detections\water_level_ranges.csv")



