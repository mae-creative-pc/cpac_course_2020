
from packaging import version
pv=version.parse
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3' 

print("### TESTING LIBRARIES...")
try:
    import numpy
except Exception as exc:
    print("Failed to import the package numpy")
try:
    import scipy
except Exception as exc:
    print("Failed to import the package scipy")
try:
    import librosa
except Exception as exc:
    print("Failed to import the package librosa")
try:
    import tensorflow
except Exception as exc:
    print("Failed to import the package tensorflow")
try:
    import pythonosc
except Exception as exc:
    print("Failed to import the package python-osc")
try:
    import sklearn
except Exception as exc:
    print("Failed to import the package scikit-learn")
try:
    import cv
except Exception as exc:
    print("Failed to import the package cv")
try:
    import requests
except Exception as exc:
    print("Failed to import the package requests")
try:
    import flask
except Exception as exc:
    print("Failed to import the package flask")

try:
    import matplotlib
except Exception as exc:
    print("Failed to import the package matplotlib")
try:
    import pandas
except Exception as exc:
    print("Failed to import the package pandas")
try:
    import seaborn
except Exception as exc:
    print("Failed to import the package seaborn")
try:
    import ipykernel
except Exception as exc:
    print("Failed to import the package ipykernel")


if not pv("1.18") <= pv(numpy.__version__) < pv("1.19"):
    print("The version %s of the package  numpy does not match with that of the requirements file"%numpy.__version__)
if not pv("1.4") <= pv(scipy.__version__) < pv("1.5"):
    print("The version %s of the package  scipy does not match with that of the requirements file"%scipy.__version__)
if not pv("0.8") <= pv(librosa.__version__) < pv("0.9"):
    print("The version %s of the package  librosa does not match with that of the requirements file"%librosa.__version__)
if not pv("2.2") <= pv(tensorflow.__version__) < pv("2.3"):
    print("The version %s of the package  tensorflow does not match with that of the requirements file"%tensorflow.__version__)
if not pv("0.23") <= pv(sklearn.__version__) < pv("0.24"): 
    print("The version %s of the package sklearn does not match with that of the requirements file"%sklearn.__version__)
if not pv("1.0") <= pv(cv.__version__) < pv("1.1"):
    print("The version %s of the package  cv does not match with that of the requirements file"%cv.__version__)
if not pv("2.24") <= pv(requests.__version__) < pv("2.25"):
    print("The version %s of the package  requests does not match with that of the requirements file"%requests.__version__)
if not pv("1.1") <= pv(flask.__version__) < pv("1.2"):
    print("The version %s of the package  flask does not match with that of the requirements file"%flask.__version__)
if not pv("3.3")<=pv(matplotlib.__version__)< pv("3.4"):
    print("The version %s of the package matplotlib does not match with that of the requirement file"%matplotlib.__version__)
if not pv("1.1")<=pv(pandas.__version__)< pv("1.2"):
    print("The version %s of the package pandas does not match with that of the requirement file"%pandas.__version__)
if not pv("0.10")<=pv(seaborn.__version__)< pv("0.11"):
    print("The version %s of the package seaborn does not match with that of the requirement file"%seaborn.__version__)
if not pv("5.3")<=pv(ipykernel.__version__)< pv("5.4"):
    print("The version %s of the package ipykernel does not match with that of the requirement file"%ipykernel.__version__)
print("### END OF TESTING")


