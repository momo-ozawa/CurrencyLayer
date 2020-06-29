# CurrencyLayer
A currency converter app built with RxSwift, MVVM architecture, and the currencylayer API

## Notes

 - Rates are fetched from the [currencylayer API](https://currencylayer.com/documentation) using the free API access key.
 - Rates fetched from the API are persisted locally to limit bandwidth usage. If it's been more than 30 minutes since the last fetch, the app will refetch new rates from the API. Othewise, the app will display the previously fetched rates.
 - The base currency selection is persisted across app launches.

Exchange Rates Screen | Supported Currencies Screen 
--- | ---
![Screen Shot 2020-06-29 at 20 47 12](https://user-images.githubusercontent.com/6711616/86001460-e1174900-ba49-11ea-8beb-06fe427829e0.png) | ![Screen Shot 2020-06-29 at 20 26 08](https://user-images.githubusercontent.com/6711616/86001453-df4d8580-ba49-11ea-8164-8453fc31edca.png)