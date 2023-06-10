select *
from personal..housing 
--all xters 


select newdate , convert(date,saledate)
from personal..housing

update personal..housing 
set newdate =convert(date,saledate)

alter  table personal..housing 
add  newdate date

--correcting date 

select a.parcelid, a.propertyaddress, b.parcelid,b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from personal..housing a
join personal..housing b 
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null 

update a
set propertyaddress=isnull(a.propertyaddress, b.propertyaddress)
from personal..housing a
join personal..housing b 
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.propertyaddress is null 
--populate address date 


select propertyaddress 
from personal..housing 

select substring(propertyaddress,1, CHARINDEX(',',propertyaddress)-1) as address,
 substring(propertyaddress, CHARINDEX(',',propertyaddress)+1,len(propertyaddress))  as address
 
 -- parsename can also be used instead 
 
select parsename( replace(propertyaddress, ',','.'), 2),
parsename( replace(propertyaddress, ',','.'), 1)
from personal..housing 


Update personal..housing 
set soldasvacant=case when soldasvacant ='N' then 'No'
     when soldasvacant ='Y'then 'Yes'
	 else soldasvacant 
	 end  
update personal..housing 
set propertysplitaddress=substring(propertyaddress,1, CHARINDEX(',',propertyaddress)-1)

alter  table personal..housing 
add  propertysplitaddress nvarchar(255)


update personal..housing 
set propertysplitcity=substring(propertyaddress, CHARINDEX(',',propertyaddress)+1,len(propertyaddress))

alter  table personal..housing 
add propertysplitcity  nvarchar(255)

select*
from personal..[Housing ]

---splitting the property address 

select distinct (soldasvacant)
from personal..housing

select ownername
from personal..[Housing ]



select 
PARSENAME(replace( owneraddress, ',', '.'), 3)     ,
PARSENAME(replace( owneraddress, ',', '.'), 2),
PARSENAME(replace( owneraddress, ',', '.'), 1)
from personal..housing

--- splitting owner names



update personal..housing 
set propertyaddressnamesplit= PARSENAME(replace( owneraddress, ',', '.'), 3) 

alter  table personal..housing 
add  propertyaddressnamesplit nvarchar(255)


update personal..housing 
set porpertyaddresstown=PARSENAME(replace( owneraddress, ',', '.'), 2)

alter  table personal..housing 
add  porpertyaddresstown nvarchar(255)



update personal..housing 
set propertyaddresscity=PARSENAME(replace( owneraddress, ',', '.'), 1)

alter  table personal..housing 
add propertyaddresscity nvarchar(255)

-- how to seperate propertyaddressname 


with RowNumCTE AS (
select *,
row_number() over(
    partition by parcelid,
	             propertyaddress, 
				 saleprice,
				 saledate,
				 legalreference
                 order by 
				 uniqueid ) Row_num
 from personal..housing 
--ORDER BY PARCELID 
)
select *
from RowNumCTE
where Row_num>1
order by propertyaddress 

----- to select dublicate from a table 


with RowNumCTE AS (
select *,
row_number() over(
    partition by parcelid,
	             propertyaddress, 
				 saleprice,
				 saledate,
				 legalreference
                 order by 
				 uniqueid ) Row_num
 from personal..housing 
 )               
Delete
from RowNumCTE
where Row_num>1
order by propertyaddress 

--- to delete dublicate 

-

select *
from personal..housing 

alter table personal..housing 
drop column propertyaddress,owneraddress, taxdistrict

alter table personal..housing 
drop column saledate

-----to delete unused column 