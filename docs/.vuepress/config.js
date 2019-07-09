module.exports = {
  themeConfig: {
    sidebar: "auto",
    repo: "mitre/heimdall",
    editLinks: true,
    docsBranch: "landing-page",
    repoLabel: "Edit this project",
    nav: [
      { text: "Home", link: "/" },
      { text: "Get Started", link: "/getStarted/" },
      { text: "About Heimdall", link: "/why/" },
      {
        text: "Install",
        link: "/install/",
        items: [
          { text: "Developers", link: "/install/developers/" },
          { text: "Deployers", link: "/install/deployers/" }
        ]
      },
      { text: "Documents", link: "/documents/" },
      { text: "Developers", link: "/developers/" },

      { text: "Check out a demo", link: "http://xk3r.hatchboxapp.com/" }
    ]
  },
  logo: "./logo.png",
  title: "Heimdall",
  description: "Centralized aggregation tool for Inspec evaluations."
};
