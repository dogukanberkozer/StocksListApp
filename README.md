# StocksListApp

https://github.com/user-attachments/assets/f2bf421e-8a6e-41dd-9e33-8aff5b38bfbc

The screen consists of a header and a list.

Rows on the list shows the following information
- Name of the stock
- Last update time
- An arrow indicator that changes with the price of the stock.
- The two columns at the right can show various data according to the selection in the header.

The two columns at the right of the header are also buttons to change the data that is shown on the rows. When user change the column selection, the corresponding data in the column of the rows should be updated.

**Service**

The stock list is created from Service 1 using "mypagedefaults" key.
- cod: The name of the stock
- tke: The key to be used for data request

The fields that can be selected from the header is created from Service 1 using "mypage" key. The first two item will be shown by default.
- name: The name of the column
- key: The column key to be used for data request

Service 2 will be used to fetch stock data. "fields" and "stcs" are the query parameters that can change.
- fields: The list of field keys. You need to seperate them with ","
- stcs: The list of stock keys. You need to seperate them with "~"

**Details**

- The list needs to be updated every 1 second.
- When the data is received, the lines of the symbols whose "clo" field (clock) has changed should be highlighted briefly. The change will be calculated by comparing last data and the previous one.
- The arrow direction will change based on "las" field (last price) difference. The change will be calculated by comparing last data and the previous one.
- The values of the difference (ddi) and %difference (pdd) columns should be green if positive and red if negative.
