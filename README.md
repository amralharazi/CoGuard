# CoGuard
An iOS application to predict and track Covid-19 cases.

https://github.com/amralharazi/CoGuard/assets/55652499/c43798f5-237d-4aca-882c-a7c78d00d995


## Description
Users can register as either a patient or a doctor. Patients have the ability to create examination cards, attach visuals for a more accurate evaluation, and send them to doctors to receive personalized feedback.

On the other hand, doctors can review the submitted cards, provide feedback to patients, and view the most frequently observed symptoms along with their respective percentages.

All users have access to global Covid-19 statistics and news. Recent cases with a probability higher than 50% are displayed as circles on the map. Additionally, users can find information about the nearest hospitals in Cyprus and access their public Covid-19 case data.
## Prediction
Back in 2020, when the outbreak of Covid-19 started, some researchers suggested that certain combinations of symptoms, including loss of smell and taste, fatigue, persistent cough, and loss of appetite, were important indicators of Covid-19. Based on this symptom-oriented prediction, they proposed two models.

Model 1 (Menni et al., 2020a):

PredictionModel 1 = -1.32 - (0.01 * age) + (0.44 * sex) + (1.75 * loss of smell and taste) + (0.31 * severe persistent cough) + (0.49 * severe fatigue) + (0.39 * skipped meals) (1)

In this model, if an individual reports experiencing all these symptoms, each symptom is assigned a value of 1; otherwise, the value is 0. The sex parameter is coded as "1" for male participants and "0" for female participants. The resulting value is then converted to a predicted probability using the formula exp(x)/(1+exp(x)). The model assigns estimated Covid-19 cases for probabilities greater than 0.5 and controls for probabilities less than 0.5 (Menni et al., 2020a).

The same researchers proposed another linear model based on a combination of loss of smell and taste, fever, fatigue, persistent cough, diarrhea, abdominal pain, and loss of appetite.

Model 2 (Menni et al., 2020b):

PredictionModel 2 = -2.30 + (0.01 * age) - (0.24 * sex) + (1.6 * loss of smell and taste) + (0.76 * fever) + (0.33 * persistent cough) + (0.25 * fatigue) + (0.31 * diarrhea) + (0.46 * skipped meals) - (0.48 * abdominal pain) (2)

The parameter values in this model are the same as described by the researchers above.

The probability is then calculated by taking the average of the results from the two models.

```swift
    let model1 = -1.32
        - (0.01 * Double(age))
        + (0.44 * sexValue)
        + (1.75 * lossOfSmellAndTasteValue)
        + (0.31 * persistentCoughValue)
        + (0.49 * fatigueValue)
        + (0.39 * inappetenceValue)
        
        let  model1Probability = exp(model1) / (1 + exp(model1))
        
        let model2 = -2.30
        + (0.01 * Double(age))
        - (0.24 * sexValue)
        + (1.6 * lossOfSmellAndTasteValue)
        + (0.76 * feverValue)
        + (0.33 * persistentCoughValue)
        + (0.25 * fatigueValue)
        + (0.31 * diarrheaValue)
        + (0.46 * inappetenceValue)
        - (0.48 * abdominalPainValue)
        
        let  model2Probability = exp(model2) / (1 + exp(model2))
        
        let averageProbability =  ((model1Probability+model2Probability)/2) * 100
```
## Getting started
1. Make sure you have Xcode 14 or higher installed on your computer
2. To install thrid-part libraries, make sure Cocoapods is installed too.
3. Download/clone CoGuard to a dicretory on your computer.
4. Run the current active scheme.

## Usage
To use the app, you will need to register. You only need to provide an email that you own to proceed. After verifying your email, you will be able to explore CoCuard in depth.

## Architecture
* CoGuard has been implemented utilizing the MVC architecture.
* Model has the important data to retrieve and render from the database.
* View has the UI components that will appear on the screen
* Controller is responsible for handling the interaction of the user and updating the model accordingly.
* Firebase is used as the backend system of CoGuard.
  
## Structure
* **Delegate**: AppDelegate and SceneDelegate files are saved here.
* **Networking**: All files and classes that are related to communicating with the APIs and Firebase and parsing their responses.
* **Utils**: Animation, constants, extensions, custom fonts all are under this folder.
* **Model**: Contains files to represent data to be sent and fechted from the database or to facilitate reuseability of UI elements.
* **View**: All UI elements can found in this folder. From LaunchScreen to all different Storyboards and cells, etc.
* **Controller**: In this folder, all classes of the aforementioned views can be found.

## Dependencies
For this project, Cocoapods is opted for managing the dependencies. List of incorporated pods:

* Firebase
* Alamofire
* SDWebImage
* lottie-ios
* IQKeyboardManagerSwift

## APIs
* For external API requests, Alamofire-based network layer is created that utalizes the await-async concurrency structure.
* For Firebase requests, completion handler is used instead.
* External APIs used are: https://rapidapi.com/api-sports/api/covid-193 for statistics, and https://rapidapi.com/newscatcher-api-newscatcher-api-default/api/covid-19-news/ for displaying news.

## References
  1. Menni, C., Valdes, A., Freydin, M. B., Ganesh, S., Moustafa, J. E. S., Visconti, A., ... & Wolf, J. (2020b). Loss of smell and taste in combination with other symptoms is a strong predictor of Covid-19 infection. MedRxiv.
  2. Merrell, R. C. and Doarn, C. R. (2014). m-Health. Telemedicine Journal and E-Health 2, 99–101.
