# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

import argparse
import os
import shutil
import subprocess
import tempfile

REPOS = [
    {
        "url": "https://{}@wwwin-github.cisco.com/netascode/nac-sdwan-terraform.git",
        "type": "internal",
        "commit_message": "Nac sdwan updates",
        "update_release_only": True,
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./.rules",
            },
            {
                "src": "../templates/sdwan/test",
                "dst": "./tests/templates",
            },
            {
                "src": "../jinja_filters",
                "dst": "./tests/filters",
            },
        ],
        "files": [
            {
                "src": "../schemas/sdwan.yaml",
                "dst": "./.schema.yaml",
            },
        ],
    },
    {
        "url": "https://{}@github.com/netascode/terraform-sdwan-nac-sdwan.git",
        "type": "external",
        "commit_message": "Nac sdwan updates",
        "files": [
            {
                "src": "../defaults/sdwan.yaml",
                "dst": "./defaults/sdwan.yaml",
            },
        ],
    },
    {
        "url": "https://{}@wwwin-github.cisco.com/netascode/onboarding-tool.git",
        "type": "internal",
        "update_release_only": True,
        "commit_message": "Nac sdwan updates for onboarding tool",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./onboarding-data/sdwan/repository-template/.rules",
            },
            {
                "src": "../templates/sdwan/test",
                "dst": "./onboarding-data/sdwan/repository-template/tests/templates",
            },
            {
                "src": "../jinja_filters",
                "dst": "./onboarding-data/sdwan/repository-template/tests/filters",
            },
        ],
        "files": [
            {
                "src": "../schemas/sdwan.yaml",
                "dst": "./onboarding-data/sdwan/repository-template/.schema.yaml",
            },
        ],
    }
]


def print_message(message):
    print(
        "--------------------------------------------------------------------------------"
    )
    print(message)
    print(
        "--------------------------------------------------------------------------------"
    )


def update_repo(repo):
    with tempfile.TemporaryDirectory() as dirname:
        if repo["type"] == "internal":
            url = repo["url"].format(os.getenv("DD_INTERNAL_GITHUB_TOKEN"))
        elif repo["type"] == "external":
            url = repo["url"].format(os.getenv("DD_GITHUB_TOKEN"))
        args = ["git", "clone", url, dirname]
        print_message("git clone")
        subprocess.run(args, check=True)
        # copy files and dirs
        for dir in repo.get("directories", []):
            shutil.copytree(
                dir["src"], os.path.join(dirname, dir["dst"]), dirs_exist_ok=True
            )
        for file in repo.get("files", []):
            shutil.copyfile(file["src"], os.path.join(dirname, file["dst"]))
        cwd = dirname
        args = ["git", "add", "--all"]
        print_message(args)
        subprocess.run(args, cwd=cwd, check=True)
        args = ["git", "diff", "--cached", "--exit-code"]
        print_message(args)
        r = subprocess.run(args, cwd=cwd)
        if r.returncode > 0:
            if repo["type"] == "internal":
                subprocess.run(
                    ["git", "config", "user.email", "digidev.gen@cisco.com"],
                    cwd=cwd,
                    check=True,
                )
                subprocess.run(
                    ["git", "config", "user.name", "digidev.gen"], cwd=cwd, check=True
                )
            elif repo["type"] == "external":
                subprocess.run(
                    ["git", "config", "user.email", "netascode-gen@cisco.com"],
                    cwd=cwd,
                    check=True,
                )
                subprocess.run(
                    ["git", "config", "user.name", "netascode-gen"], cwd=cwd, check=True
                )
            args = ["git", "commit", "-m", repo["commit_message"]]
            print_message(args)
            subprocess.run(args, cwd=cwd, check=True)
            args = ["git", "push"]
            print_message(args)
            subprocess.run(args, cwd=cwd, check=True)


def update_repos():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--release",
        help="Update repos marked as 'update_release_only'",
        action="store_true",
    )
    args = parser.parse_args()
    for repo in REPOS:
        if repo.get("update_release_only", False) and not args.release:
            continue
        print("\n-> Updating repo {}\n".format(repo["url"]))
        update_repo(repo)


if __name__ == "__main__":
    update_repos()
