import {
  Controller,
  Get,
  Post,
  Param,
  Body,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from './prisma.service';

@Controller('polls')
export class AppController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  async getPolls() {
    let polls = await this.prisma.poll.findMany({
      include: { options: true },
      orderBy: { createdAt: 'desc' },
    });

    // Auto-seed if the database is empty
    if (polls.length === 0) {
      await this.prisma.poll.create({
        data: {
          question: 'React Native vs Flutter?',
          options: {
            create: [{ text: 'React Native' }, { text: 'Flutter' }],
          },
        },
      });
      polls = await this.prisma.poll.findMany({ include: { options: true } });
    }
    return polls;
  }

  @Post(':pollId/vote')
  async vote(
    @Param('pollId') pollId: string,
    @Body('optionId') optionId: string
  ) {
    // THE FLEX: Artificial 2-second delay to prove Flutter's Optimistic UI works
    await new Promise((resolve) => setTimeout(resolve, 2000));

    try {
      const updatedOption = await this.prisma.option.update({
        where: { id: optionId },
        data: { votes: { increment: 1 } },
      });
      return { success: true, option: updatedOption };
    } catch (e) {
      throw new NotFoundException('Option not found');
    }
  }
}
