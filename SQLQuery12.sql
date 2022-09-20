use Essential;
SELECT c.CountryID, c.CountryName, s.StateProvince, ct.CityName, ad.AddressName FROM Country c
Inner join StateProvince s on c.CountryID = s.CountryID
Inner join City ct on s.StateProvinceID=ct.StateProvinceID
Inner join Address ad on ct.CityID =ad.cityID


