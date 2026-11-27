
import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv("cleaned_clinical_trials.csv")

# Chart 1: Top 8 Sponsors in Diabetes Trials
top_sponsors = df["sponsor"].value_counts().head(8)
plt.figure(figsize=(10, 5))
top_sponsors.sort_values().plot(kind="barh", color="#2b5c8f")
plt.title("Top 8 Sponsors in Diabetes Clinical Trials")
plt.xlabel("Number of Trials")
plt.tight_layout()
plt.savefig("top_sponsors_chart.png")
plt.close()

# Chart 2: Trials by Phase
phase_counts = df["phases"].value_counts()
plt.figure(figsize=(8, 4))
phase_counts.plot(kind="bar", color="#3a8f6e")
plt.title("Diabetes Clinical Trials by Phase")
plt.ylabel("Number of Trials")
plt.xticks(rotation=30)
plt.tight_layout()
plt.savefig("trials_by_phase_chart.png")
plt.close()

print("Saved Python EDA charts successfully!")
