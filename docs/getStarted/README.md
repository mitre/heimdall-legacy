# Getting Started

If you still need to install Heimdall, click [here](/install/)

Once you install Heimdall, you will have to create your first account. By default this account will have full admin rights and you will then be able to create other users and grant them access to roles, circles (groups) and teams as you need. You can add your first user by selecting 'Create Account' and then logging in as that user.

## Using LDAP and OAuth

Heimdall also supports connecting to your corporate LDAP and other OAuth authentication services but the authorization of those users in Heimdall is managed via the application itself (PRs Welcome).

## Uploading Results Manually

Once you have an account you can upload InSpec JSONs (see reporters) for evaluations and profile then view them by clicking on the evaluations and profiles tab at the top of the page.

## Supporting Groups/Circles and Multiple Teams

Heimdall supports separating users into groups we call 'Circles' which is basically just groups and roles. This will allow you to deploy a command service which many teams can use, allow your AO or Security Teams to review and comment on multiple teams work while still providing separation of roles and responsibilities.

The Heimdall Administrator can define Circles and add users to those circles. At the moment, this is done directly in the Heimdall application (PRs Welcome) and teams can push their results to a circle via curl. This will allow multiple work streams to happen and easy integration into workflow processes while trying to keep the human element from going blind :).

My default everything goes to the public circle, you should define your circles with respect to the R&R of your organization and project and program structure.

Although it's just a suggestion, we have also found that having a few generic results in the public circle is useful to help easy demonstrations or conversations to happen. This will allow all visitors to view the profile/evaluation you uploaded.

## Remote Upload and Pipeline Integration via CURL

To upload through curl you'll need an API key. This is located on your profile page which can be reached by clicking on your user name in the top right corner, then on profile.

The upload API takes three parameters: the file, your email address, and your API key.

curl -F "file=@FILE_PATH" -F email=EMAIL -F api_key=API_KEY http://localhost:3000/evaluation_upload_api

## Useful Tools

The inspec_tools and heimdall_tools also have useful features that help you manage your results, do integration with your CI/CD and DevOps pipelines and get your teams working.

inspec_tools has the compliance and summary functions which will help you define a go/no-go for your pipeline results and allow you to define your thin blue line of success or failure. Incorporating these tools, you can scan, process, evaluate and upload your results to allow your various teams and stages to define the granularity they need while still following the spirit of the overall DevSecOps process as a whole.

For example, the compliance function will let you easily use Jenkins, GitLab/Hub CICD or Drone to have clean pass/fail with an exit 0 or exit 1 and allow you to define exactly the high, medium and low and overall compliance score that you and your Security Official agreed to in production or in development.

NOTE You should always test like you are in production, that is where you are going to end up after all!!
