import os
import csv
import random

def ReadDat(path):
    '''
    Read the content from *.dat and return
    DATA (list[list]): [[UserID, MovieID, Rating], ...]
    '''
    DATA = []
    for line in open(path, 'r'):
        content = line.split('::')
        UserID, MovieID, Rating, _ = content
        DATA.append([UserID, MovieID, Rating])
    return DATA

def WriteCsv(path, DATA, ID):
    '''
    Write csv file for a partial dataset DATA (given by indices ID)
    '''
    with open(path, 'w', newline='') as f:
        # create writer
        writer = csv.writer(f)
        
        # write the column name
        writer.writerow(['UserID', 'MovieID', 'Rating'])

        # write the content
        for ind in ID:
            writer.writerow(DATA[ind])
    return

if __name__ == '__main__':
    '''
    Goal: split the dataset (ratings.dat) to 9:1 ratio

    The format in ratings.dat is:
        UserID::MovieID::Rating::Timestamp

    We split them into 9:1 and write them to Train.csv and Valid.csv
    '''
    folder_path = os.path.join('dataset', 'ml-10m')
    rating_path = os.path.join(folder_path, 'ratings.dat')

    # read ratings.dat
    DATA = ReadDat(rating_path)
    N = len(DATA)
    
    # random sampling
    TrainID = random.sample(range(N), int(0.9*N))  # 90 percent
    ValidID = list(set(range(N)) - set(TrainID))

    TrainID = sorted(TrainID)
    ValidID = sorted(ValidID)

    # write csv
    WriteCsv(os.path.join(folder_path, 'Train.csv'), DATA, TrainID)
    WriteCsv(os.path.join(folder_path, 'Test.csv'), DATA, ValidID)
