use Portfolio_Project

Select * from Housing
where PropertyAddress is null

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME like 'Housing'


select ParcelID, PropertyAddress from housing
where PropertyAddress is null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from 
Housing as a 
join Housing as b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--Handled Null in PropertyAddress
update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from 
Housing as a 
join Housing as b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

Select Distinct PropertyCity from Housing
-- Splitting Address into three columns Address , city

--Address Split
Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) from Housing
--City Split
Select Trim(SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))) from Housing

Alter Table Housing
Add PropertyAddressNew Varchar(Max)

Update Housing
Set PropertyAddressNew = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter Table Housing
Add PropertyCity Varchar(Max)

Update Housing
Set PropertyCity =Trim(SUBSTRING(PropertyCity,CHARINDEX(',',PropertyCity)+1,len(PropertyCity)))

Update Housing
Set PropertyCity = UPPER(Left(PropertyCity,1)) + LOWER(SUBSTRING(PropertyCity, 2, len(PropertyCity)))

--Spliting Owner Address into 3(Address, City, State)

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from Housing

Alter Table Housing
Add OwnerSplitAddress Nvarchar(255);

Update Housing
Set  OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table Housing
Add OwnerSplitcity Nvarchar(255);

Update Housing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table Housing
Add OwnerSplitState Nvarchar(255);

Update Housing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


--Changing the datatype of SoldAsVacant to make the column as Yes/No

Alter table Housing
Alter Column SoldAsVacant Varchar(10)

Update Housing
Set SoldAsVacant = 
Case 
when SoldAsVacant = 0 then 'No'
when SoldAsVacant = 1 then 'Yes'
End


-- Removing Duplicates
with rownumcte as (
select *,
Row_Number() over(Partition by parcelid,propertyAddress,saledate,saleprice,legalreference order by uniqueid asc) as Row_Num
from Housing
)

Delete from rownumcte
where Row_Num > 1


Alter table Housing
Drop Column PropertyAddress,Taxdistrict