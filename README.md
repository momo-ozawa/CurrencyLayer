# CurrencyLayer
A currency converter app built with RxSwift, MVVM architecture, and the CurrencyLayer API

## Notes

 - Rates are fetched from the [currencylayer API](https://currencylayer.com/documentation) using the free API access key.
 - Rates fetched from the API are persisted locally to limit bandwidth usage. If it's been more than 30 minutes since the last fetch, the app will refetch new rates from the API. Othewise, the app will display the previously fetched rates.
 - The base currency selection is persisted across app launches.