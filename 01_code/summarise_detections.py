import pandas as pd
import numpy as np

reciever_detections=pd.read_csv(r"C:\Users\wout.decrop\project_environment\hackaton\OpenSeaLabHackathon_SmoothSharks\00_data\01_acoustic_detections\receiver_deployments.csv")
shark_detections=pd.read_csv(r"C:\Users\wout.decrop\project_environment\hackaton\OpenSeaLabHackathon_SmoothSharks\00_data\01_acoustic_detections\sharks_detections.csv")

shark_detections

shark_detections=shark_detections.loc[shark_detections['sensor_unit'] == "Meters"]
np.unique(shark_detections["detection_id"])
shark_detections.columns
shark_detections["parameter"]
shark_detections.groupby(['station_name','acoustic_tag_id'])['parameter']
shark_detections.groupby(['station_name','acoustic_tag_id']).agg({'parameter': ['mean', 'min', 'max']})
t=shark_detections.groupby(['station_name','acoustic_tag_id']).agg({'parameter': ['mean', 'min', 'max']})
shark_detections.loc[(0 <= shark_detections['parameter'] <= 10) ]
shark_detections[shark_detections['parameter'].between(0, 10)]

shark_detections.groupby(pd.cut(shark_detections['parameter'], [0, 25, 50, 75, 100])).sum()

m=pd.cut(shark_detections['parameter'], [0, 10,20,30,40,50])
shark_detections["range"]=m
shark_detections.groupby(['station_name','acoustic_tag_id','range']).count()
shark_detections