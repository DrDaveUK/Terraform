# Overview

To create a series of groups which have EntraID roles assigned to them

## Summary

The code will create a series of groups with a naming convention of

"PIM Enabled Role - {EntraID Role}"

The tenant level roles are defined in:

```
azure_roles = [
    "Global Administrator",
    "Global Reader",
    "Groups Administrator",
    ...
    ...
```

The role names need to match those as defined in this Microsoft document
- https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference

## Notes

I know normally data will be hosted within a file on its own, but I have compressed it to give the full solution in a single file so it is easier to understand the solution

