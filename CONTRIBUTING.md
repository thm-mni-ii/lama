# Contributing Guideline

This project is part of the software technology module at the "THM-Mittelhessen". Only the current members of the group "Flutter-App" are allowed to contribute to this project.
The group leaders are Dario Pläschke and Franz Johann Leonhardt who will manage the jira platform, distribute the tasks among the members etc.


## Workflow

### Issues
All group members are allowed to **create** issues on the jira-platform under relating epic issues. Each issue begins with an idea that outlines a certain topic. This topic can be an occuring bug, security leaks, requested feature, etc. 
When creating an issue a very **detailed explaination** is necessary. Be sure that this includes a describing title combined with an detailed description. This description depends on the certain topic and should consists of all necessary informations. 
A bug report for example should consists of:

- steps to recreate the bug
- log from flutter dev tools
- all further informations

**Labels** are essential for further filtering and sorting. Thats why every issue should have at least one label showing the content. If there is no matching one you should create one in consultation with the group leaders.

Another part are **components** which must be selected appropriately.


### Assign and edit Issue

Issues are assigned by the group leaders or in consultation with them. When editing an issue make sure that it has been moved to the **in progress** column at the kanban board. After that you create the **branch** starting with the _number_ of the issue (SWTP21T3-**XXXXX** - xx is the number). Make sure you are in the right branch from which you want to branch from and your local is up-to-date. This branch is mainly ***develop*** and sometimes the ***epic branch*** of an epic issue.

```
git checkout develop
git pull origin develop
git checkout -b <branch_name>
```


### Commits

Within a branch there are rules for each commit:

- each commit have only **one specific goal**
- each goal **should not split up** into multiple commits

In addition to that the _commit message_ should follow a specific pattern:

- the **header** (first row) should clearly state which change has been approached
- the **header** must not be longer than 50 characters
- the **header** starts with a capital letter
- the **header** is written in presence imperative (Add ..., Change ...)
- the header is followed by an **empty row**
- all **remaining rows** are used to further describe the commit and are not subject to any rules


```
git add <file>
git commit
git push origin <branch_name>
```


### Merge-Requests

A branch of an issue leads to a merge-request to the **develop** or **epic-issue** branch. In order to accept the merge request the following rules must be observed:

- the branch is **rebased**

```
git checkout <branch_name>
git rebase -no-ff <develop or epic issue>
[fix merge conflicts]
git push -f origin <branch_name>
```

- the **review process** is carried out by at least one other group member
- make sure to enter the **required time** for this issue
- the **merge** should not be handeled by the requesting person.