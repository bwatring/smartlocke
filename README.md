### SMART LOCKY 👋
Hello SmartLocky

### DESCRIPTION
SmartLocky is a project that will automatically unlock a user if they are locked out without prompting again, and let the tech user know whether they were  locked out or not and what kind of lockout that user is experiencing.


### 🧰 Languages and Tools

<img align="left" alt="HTML" width="30px" style="padding-right:10px;" src="https://pomodoneapp.com/assets/images/service-landing/gitkraken-glo/gitkraken_glo.png" />
<img align="left" alt="CSS" width="30px" style="padding-right:10px;" src="https://p1.hiclipart.com/preview/49/692/938/radial-icon-set-2-powershell-blue-and-white-arrow-icon-art-png-clipart-thumbnail.jpg" />
<img align="left" alt="GitHub" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" />
<br />

### 🤝SlsStatusTool
- The slsStatusTool was instrumental because we needed to run slsStatusTool with the lockedout user's email.

### ⏩Power Automate
- Power Automate is how we automated this reocurring task.

### 🔐 The Different Types of Lockouts:
- Familiar Lockout
- Unknown Lockout
- Both (Familiar & Unknown Lockout)


### 📊 ABOUT SMARTLOCKY

- 🌱SMARTLOCKY takes in a parameter which is the user's abc123
- 💬if FamiliarLockout is True, log the info and run SLStatusTool again with the -FAM switch on
- 📫 if UnknownLockout is True, log the info and run SLStatusTool again with the -UNK switch on
- 😄if both lockouts are True, then run the SLStatusTool with both switches on
- ⚡if both are false, then do nothing
- 👯 This is a collab project with Ricky and I

### ☑ How We Went About the Process

- [x] rewrite this script from scratch so function is better/more efficient
- [x] replace getting abc123 by a mandatory parameter
- [x] Get the email from abc123 from Active Directory
- [x] Run SLSSTatusTool with the email and get the output
- [x] Log all of the info and send back as a message explaining what was done, whether user was locked or not and if they were unlocked
- [ ] PowerAutomate piece
- [ ] reads message from teams and send https request to gitlab
- [ ] gitlab gets triggered by the http request, and runs yml file
- [ ] yml file runs the main script

