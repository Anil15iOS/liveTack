import SwiftUI

struct TakeCell: View {
  let take: Take

  var body: some View {
    Card {
      HStack {
        Text(take.daysAgo)
          .font(Font.LiveTake.body)
          .foregroundColor(Color.LiveTake.labelGray)
        Spacer()

        HStack {
          Text(take.leagueType.rawValue)
          Image(take.leagueType.icon, bundle: .module)
        }
        .font(Font.LiveTake.body)
        .foregroundColor(Color.LiveTake.labelGray)
      }
      .padding(.horizontal)

      if let image = take.image {
        Image(image, bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(.horizontal, 8)
      }

      Avatar(user: take.user, isLiveTake: false)

      QuoteDivider()
        .padding(.horizontal)

      Text(take.title)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .font(.custom("DIN Condensed Bold", size: 23))
        .frame(maxWidth: .infinity)

      PollButton(leftPoll: take.leftPoll, rightPoll: take.rightPoll)

      Text("VOTE TO VIEW RESULTS")
        .foregroundColor(.white)
        .font(.LiveTake.body)
        .kerning(1)

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          ForEach(emojis) { emoji in
            HStack(spacing: 2) {
              Text("\(emoji.icon)")
                .foregroundColor(.white)
              Text("\(emoji.votes)")
                .foregroundColor(.white)
                .font(.custom("OpenSans-Bold", size: 15, relativeTo: .body))
            }
            .padding(8)
            .background(Capsule().foregroundColor(.LiveTake.topBarButtonTint))
          }
        }
      }
    }
  }
}

struct LiveTakeCell: View {
  let liveTake: LiveTake
  var body: some View {
    Card {
      HStack(spacing: 4) {
        if liveTake.isLive {
          Circle()
            .fill(Color.red)
            .frame(width: 5, height: 5)
        }
        Text(liveTake.time)
          .foregroundColor(liveTake.isLive ? .white : .LiveTake.labelGray)
          .font(.custom("OpenSans-Bold", size: 13, relativeTo: .body))
          .bold()
      }
      .frame(maxWidth: .infinity)
      .overlay(alignment: .trailing) {
        HStack {
          HStack {
            Text(liveTake.leagueType.rawValue)
            Image(liveTake.leagueType.icon, bundle: .module)
          }
          .font(Font.LiveTake.body)
          .foregroundColor(Color.LiveTake.labelGray)
          Image(liveTake.streamingType.icon, bundle: .module)
            .resizable()
            .frame(width: 24, height: 24)
        }
      }
      .overlay(alignment: .leading) {
        Text(liveTake.daysAgo ?? "")
          .font(Font.LiveTake.body)
          .foregroundColor(Color.LiveTake.labelGray)
      }
      .padding(.horizontal, 8)
      .padding(.bottom, liveTake.image == nil ? 16 : 0)


      HStack {
        if let image = liveTake.image {
          Image(image, bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
        if let secondImage = liveTake.secondImage {
          Image(secondImage, bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
      }
      .padding(.horizontal, 8)

      Text(liveTake.title)
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .font(.custom("DIN Condensed Bold", size: 23, relativeTo: .title2))
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
        .padding(.horizontal, 8)

      HStack(alignment: .centerVsAndImage) {
        Avatar(user: liveTake.leftUser, isLiveTake: true)
        Text("vs")
          .foregroundColor(Color.hex(0x5B5B5B))
          .font(.custom("NunitoSans-Bold", size: 17, relativeTo: .body))
          .alignmentGuide(VerticalAlignment.centerVsAndImage) { dimensions in dimensions[VerticalAlignment.center] }
        Avatar(user: liveTake.rightUser, isLiveTake: true)
      }
      .padding(.horizontal, 8)

      PollButton(leftPoll: liveTake.leftPoll, rightPoll: liveTake.rightPoll)

      Button {
      } label: {
        Text("Join".uppercased())
          .foregroundColor(Color.LiveTake.primaryBackgroundColor)
          .font(.custom("NunitoSans-ExtraBold", size: 16, relativeTo: .body))
          .frame(width: 112, height: 36)
      }
      .controlSize(.small)
      .buttonStyle(.borderedProminent)
      .buttonBorderShape(.capsule)
      .tint(.white)
      .padding(.top, 8)
      .frame(maxWidth: .infinity)
      .overlay(alignment: .trailing) {
        Text(liveTake.bottomNumber)
          .font(Font.LiveTake.body)
          .foregroundColor(Color.LiveTake.labelGray)
      }
      .padding(.horizontal, 8)
    }
  }
}

struct Card<Content: View>: View {
  @ViewBuilder let content: () -> Content

  var body: some View {
    VStack {
      content()
        .frame(maxWidth: .infinity)
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 12)
    .background(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(Color.LiveTake.primaryBackgroundColor)
    )
  }
}
