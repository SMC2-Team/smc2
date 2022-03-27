import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import numpy as np
import statistics

numberRuns = 1

programs = ["LR-parser", "pay-gap", "h_analysis", "private-branching", 
      "private-branching-mult", "private-branching-add", "private-branching-reuse"]


''' File names for local times '''
statsFileName = "statsLocal.csv"
graphFileName = "LocalPercentDiff.png"

''' File names for distributed times '''
#statsFileName = "statsDist.csv"
#graphFileName = "DistPercentDiff.png"


'''
BEGIN data parsing functions
'''

def getNums(inFileName, outFileName, numRuns):
   data = []
   for run in range(1, numRuns+1):
      inFileNameFull = inFileName + str(run)
      try: 
         f = open(inFileNameFull, 'r')
         f.readline()
         times = []
         for line in f:
            if(line[0:5] == "Time:"):
               runtime = line[6:]
               runtime.strip()
               times.append(float(runtime))
         data.append(times)
         f.close()
      except:
         print(inFileNameFull + " not found")
         return []
   f = open(outFileName, 'w')
   f.write("Run No.,Party 3,Party 2,Party 1,Average\n")
   avgs = []
   for i in range(0, numRuns):
      n = len(data[i])
      if(n == 3):
         avg = sum(data[i])/3
         avgs.append(avg)
         f.write(str(data[i][0]) + "," + str(data[i][1]) + "," + str(data[i][2]) + str(avg) + "\n")
      elif(n == 2):
         avg = sum(data[i])/2
         avgs.append(avg)
         f.write(str(data[i][0]) + "," + str(data[i][1]) + ",ERR" + str(avg) + "\n")
      elif(n == 1):
         avg = sum(data[i])
         avgs.append(avg)
         f.write(str(data[i][0]) + ",ERR,ERR" + str(avg) + "\n")
      else:
         f.write("ERR,ERR,ERR,ERR\n")
   f.close()
   return avgs

def getAllData(dir, programs, numRuns):
   programAvgs = []
   programStDev = []
   for prog in programs:
      runtimeFileName = dir + "/runtimes/" + prog
      saveFileName = dir + "/runtimes/" + prog + "Local.csv"
      avgs = getNums(runtimeFileName, saveFileName, numRuns)
      if(len(avgs) > 0):
         programAvgs.append(statistics.mean(avgs))
      else:
         programAvgs.append(-1)
      if(numRuns > 1):
         programStDev.append(statistics.stdev(avgs))
      else:
         programStDev.append(0)
   return (programAvgs, programStDev)
   
def computeSpeedup(piccoAvg, smc2Avg, piccoStDev, smc2stDev, programs, outFileName):
   finalDiff = []
   finalStDev = []
   for i in range(0, len(piccoAvg)):
      diff = (piccoAvg[i] - smc2Avg[i])/piccoAvg[i]*100
      finalDiff.append(round(diff, 2))
      stdev = (piccoAvg[i] - (smc2Avg[i] - smc2stDev[i]))/piccoAvg[i]*100 - diff  
      finalStDev.append(round(stdev,2))
   f = open(outFileName, 'w')
   f.write("Program, PICCO Avg, SMC2 Avg, PICCO St Dev, SMC2 St Dev, Speedup, St Dev\n")
   for i in range(0, len(programs)):
      f.write("{},{},{},{},{},{},{}\n".format(programs[i], piccoAvg[i], smc2Avg[i], piccoStDev[i], smc2stDev[i], finalDiff[i], finalStDev[i]))
   f.close()
   return (finalDiff, finalStDev)    


'''
BEGIN graphing functions
'''

def graphFun(fileName, diff, stdev):
   # info to plot
   n_groups = 7
   programs = ["LR-parser", "pay-gap", "h_analysis", "pb", "pb-mult", "pb-add", "pb-reuse"]
   colors = ["red", "pink", "yellow", "lightgreen", "lightblue", "mediumpurple", "teal"]
   x = [0, 1, 2, 3, 4, 5, 6]

   # create plot
   bar_width = 1
   opacity = 0.8
   patterns = [ "//" , "\\" , "|" , "-" , "+" , "x", "o", "O", ".", "*" ]
   high = 55
   low = -25
   plt.rcParams.update({'font.size': 15})
   plt.figure(figsize=(8,5))
   for i in range(0, 7):
      plt.bar(i, diff[i], bar_width, alpha=opacity, color=colors[i],
      label=programs[i], hatch=patterns[i], yerr = stdev[i], error_kw=dict(lw=2, capsize=2, capthick=2), ecolor="goldenrod")
   plt.grid(axis='y')
   plt.xlabel('Program')
   plt.ylabel('Percent Speedup (%)')
   plt.ylim([low,high])
   plt.xticks(x, programs, rotation=45)
   plt.tight_layout()
   plt.savefig(fileName)

   plt.clf()


'''
MAIN: function calls
'''
(piccoAvg, piccoStDev) = getAllData("picco", programs, numberRuns)
(smc2Avg, smc2StDev) = getAllData("smc2", programs, numberRuns)
diff = computeSpeedup(piccoAvg, smc2Avg, piccoStDev, smc2StDev, programs, statsFileName)
# graphFun(graphFileName, diff, smc2StDev)






