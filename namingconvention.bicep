@maxLength(3)
param CustId string

// The name of the created resource type. Accepted values are defined to ensure consistency.
@allowed([
  'rg'
  'vm'
  'vnet'
  'snet'
  'nic'
  'rsv'
  'aa'
  'law'
 ])
 param resourcetype string

// The name of the subject. (same as the resource group) Accepted values are defined to ensure consistency.
@allowed([
  'hub'
  'mgmt'
  'id'
  'avd'
  'app'
 ])
 param subject string

// The environment that the resource is for. Accepted values are defined to ensure consistency.
@allowed([
  'acc'
  'dev'
  'test'
  'prod'
])
param environment string

// The function/goal of the resource, for instance the name of an application it supports
param function string

// An index number. This enables you to have some sort of versioning or to create redundancy
param index int

// First, we create shorter versions of the function.
// This is used for resources with a limited length to the name.
// There is a risk to doing at this way, as results might be non-desirable.
// An alternative might be to have these values be a parameter
var functionShort = length(function) > 5 ? substring(function,0,5) : function

// This line constructs the resource name. It uses [PH] for the resource type abbreviation.
// This part can be replaced in the final template
var resourceNamePlaceHolder = '${CustId}-${environment}-${function}-[PH]-${padLeft(index,2,'0')}'
// This line creates a short version for resources with a max name length of 24
var resourceNameShortPlaceHolder = '${CustId}-${environment}-${functionShort}-[PH]-${padLeft(index,2,'0')}'

// Storage accounts have specific limitations. The correct convention is created here
var storageAccountNamePlaceHolder = '${CustId}${environment}${functionShort}sta${padLeft(index,2,'0')}'
// VM names create computer names. These can be a max of 15 characters. So a different structure is required
var vmNamePlaceHolder = '${CustId}-${environment}-${functionShort}-${padLeft(index,2,'0')}'
