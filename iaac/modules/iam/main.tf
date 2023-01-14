resource "aws_iam_user" "users" {
  name = "cv1app"
}

resource "aws_iam_access_key" "users" {
  user = aws_iam_user.users.name
}

resource "aws_iam_group" "developers" {
  name = "cv1app-devs"
}

resource "aws_iam_group_policy_attachment" "policy-attach" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_membership" "team" {
  name = "cv1app-group-membership"

  users = [
    aws_iam_user.users.name,
  ]

  group = aws_iam_group.developers.name
}

