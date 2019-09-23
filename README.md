#  Snap BugZ
This is a small demo app to show how to 'Intercept' a user screenshot to auto-start a bug reporting workflow.

See my blog here: https://blog.warningz.com/bug-reporting-in-a-snap-snapbugz

- All of the interesting code is in the AppDelegate

Workflow in short:

- User takes a screenshot.
- Alert pops up to choose between: Report Bug, eMail a Friend, Save Image
- The view-hierarchy is captured, then wrapped in an email
- The email is pre-configure with addresses, some App info etc
- User can edit and send.
