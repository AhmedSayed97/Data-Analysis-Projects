--cleaning Data in SQL Queries


Select * From PortfolioProject..NashvilleHousing



--standardize Data Format


Select SaleDateConverted, Convert(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)




---populate property adress data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is Null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.parcelID
	 AND a.UniqueID <> b.UniqueID
Where a.propertyaddress is Null



Update a 
SET a.PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.parcelID
	 AND a.UniqueID <> b.UniqueID
Where a.propertyaddress is Null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.parcelID
	 AND a.UniqueID <> b.UniqueID
Where a.propertyaddress is Null





--Breaking out Address into Individual columns (Address, City, State)


Select PropertyAddress
From PortfolioProject..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousing

Select OwnerAddress
From PortfolioProject..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
, PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
, PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
From PortfolioProject..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)


Alter Table NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

Alter Table NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

Select *
From PortfolioProject..NashvilleHousing




--change Y and N to Yes and No in SoldAsVacant


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END





---Removing Duplicates



WITH RowNumCTE AS(
SELECT *,
	    ROW_NUMBER() OVER (
	    PARTITION BY ParcelID,
				     PropertyAddress,
				     SalePrice,
				     SaleDate,
				     LegalReference
				     ORDER BY
					       UniqueID
					      ) row_num

From PortfolioProject..NashvilleHousing
--order by ParcelID
)
SELECT * 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress




--Delete Unused Columns


Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN   OwnerAddress, TaxDistrict, PropertyAddress, SaleDate