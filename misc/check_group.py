#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 22 13:40:16 2018

@author: "Anirban Das"
"""

from boto3 import session

s = session.Session()
gg = s.client("greengrass")

b = gg.list_groups()

# =============================================================================
# groupid = "47f15b31-3d05-4980-aa97-09e9928168b1"
# 
# new_group = gg.get_group(GroupId=groupid)
# functiond = gg.get_function_definition_version(FunctionDefinitionId='10c80ac9-5c9e-44e6-bf37-e75e67753f6b',
#     FunctionDefinitionVersionId='02e3c2b1-0002-4c63-9617-cae4b40acee9')
# 
# 
# =============================================================================
role = s.client("iam")

md = role.get_role(RoleName="nsl-edgecomputingrole")